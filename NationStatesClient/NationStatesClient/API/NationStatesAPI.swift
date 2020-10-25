//
//  NationStatesAPI.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/10/2020.
//

import Foundation
import Combine

struct NationStatesAPI {}

enum Shard: String {
    case ping
    case issues
}

enum APIError: Error {
    case unauthorized // 403
    case conflict // 409
    case notConnected
    case unknown(error: Error)
}

extension APIError {
    var text: String {
        switch self {
        case .notConnected: return "There appears to be no internet connection. Are you connected?"
        default:
            return "Unknown Error"
        }
    }
}

extension NationStatesAPI {
    static func authenticatedRequest(using url: URL) -> AnyPublisher<(data: Data, response: URLResponse), APIError> {
        var request = URLRequest(url: url)
        request.setupUserAgentHeader()
        request.setupAuthenticationHeaders()
        
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .mapError({ (error) -> APIError in
                if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                    return APIError.notConnected
                }
                return APIError.unknown(error: error)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func ping(nationName: String, password: String) -> AnyPublisher<(autologin: String?, pin: String?), Error> {
        guard let url = URLBuilder.url(for: nationName, with: .ping) else { fatalError() }
        
        var request = URLRequest(url: url)
        request.setupUserAgentHeader()
        request.setupPasswordAuthenticationHeader(password)
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { (result) -> (autologin: String?, pin: String?) in
                guard let httpResponse = result.response as? HTTPURLResponse else { return (autologin: nil, pin: nil) }
                guard httpResponse.statusCode != 403 else { throw APIError.unauthorized }
                guard httpResponse.statusCode != 409 else { throw APIError.conflict }
                
                let parser = PingResponseXMLParser(result.data)
                parser.parse()
                
                if parser.ping {
                    let autoLogin = httpResponse.value(forHTTPHeaderField: AuthenticationMode.autologin.header)
                    let pin = httpResponse.value(forHTTPHeaderField: AuthenticationMode.pin.header)
                    return (autologin: autoLogin, pin: pin)
                }
                
                return (autologin: nil, pin: nil)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension NationStatesAPI {
    static func answerIssue(_ issue: Issue, option: Option) -> AnyPublisher<AnsweredIssueResultDTO, APIError> {
        guard let nationName = Authentication.shared.nationName else { fatalError() }
        guard let url = URLBuilder.answerIssueUrl(for: nationName, issue: issue, option: option) else { fatalError() }
        
        return authenticatedRequest(using: url)
            .map { result -> AnsweredIssueResultDTO in
                let parser = AnswerIssueResponseXMLParser(result.data)
                parser.parse()
                return AnsweredIssueResultDTO(resultText: parser.text,
                                              headlines: parser.headlines,
                                              reclassifications: parser.reclassifications,
                                              rankings: parser.rankings)
            }
            .eraseToAnyPublisher()
    }
}

extension NationStatesAPI {
    static func fetchImageData(_ name: String, completionHandler: @escaping (Result<Data?, APIError>) -> Void) {
        guard let url = URLBuilder.imageUrl(for: name) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            completionHandler(.success(data))
        }
    }
}


extension NationStatesAPI {
    static func request(for shards: [Shard], nation nationName: String) -> AnyPublisher<[IssueDTO], APIError> {
        guard let url = URLBuilder.url(for: nationName, with: .issues) else { fatalError() }
        
        return authenticatedRequest(using: url)
            .map({ result -> [IssueDTO] in
                let parser = IssuesResponseXMLParser(result.data)
                parser.parse()
                return parser.issues
            })
            .eraseToAnyPublisher()
    }
}
