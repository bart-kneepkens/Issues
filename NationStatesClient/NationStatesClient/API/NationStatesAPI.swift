//
//  NationStatesAPI.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/10/2020.
//

import Foundation
import Combine

struct NationStatesAPI {
    private init() {}
}

enum Shard: String {
    case ping
    case issues
    case nextissue
    case nextissuetime
}

enum AuthenticationMode {
    case pin
    case autologin
    case password
    
    var header: String {
        switch self {
        case .password: return "X-Password"
        case .autologin: return "X-Autologin"
        case .pin: return "X-Pin"
        }
    }
}

enum APIError: Error {
    case unauthorized // 403
    case conflict // 409
    case notConnected
    case unknown(error: Error)
}

typealias SimpleAuthenticationPair = (nationName: String, password: String)
typealias AuthenticationPair = (nationName: String, autologin: String?, pin: String?)

enum APIAuthenticationMethod {
    case simple(SimpleAuthenticationPair)
    case regular(AuthenticationPair)
}

extension APIError {
    var text: String {
        switch self {
        case .notConnected: return "There appears to be no internet connection. Are you connected?"
        case .conflict: return "conflict"
        case .unauthorized: return "unauthorized"
        default:
            return "Unknown Error"
        }
    }
}

extension NationStatesAPI {
    private static func authenticatedRequest(using url: URL,
                                             method: APIAuthenticationMethod) -> AnyPublisher<(data: Data, response: URLResponse), APIError> {
        var request = URLRequest(url: url)
        
        switch method {
        case .simple(let simplePair):
            request.setupUserAgentHeader(nationName: nil)
            request.setupPasswordAuthenticationHeader(simplePair.password)
        case .regular(let pair):
            request.setupUserAgentHeader(nationName: pair.nationName)
            request.setupAuthenticationHeaders(pair: pair)
        }
        
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .tryMap({ value -> (data: Data, response: URLResponse) in
                if let httpResponse = value.response as? HTTPURLResponse {
                    if httpResponse.statusCode == 409 {
                        throw APIError.conflict
                    }
                    if httpResponse.statusCode == 403 {
                        throw APIError.unauthorized
                    }
                }
                return value
            })
            .mapError({ (error) -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                }
                if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                    return APIError.notConnected
                }
                return APIError.unknown(error: error)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func ping(nationName: String, password: String) -> AnyPublisher<AuthenticationPair, APIError> {
        guard let url = URLBuilder.url(for: nationName, with: .ping) else { fatalError() }
        
        return authenticatedRequest(using: url,
                                    method: .simple((nationName: nationName, password: password)))
            .map { result -> AuthenticationPair in
                let parser = PingResponseXMLParser(result.data)
                parser.parse()
                if parser.ping, let httpResponse = result.response as? HTTPURLResponse {
                    let autoLogin = httpResponse.value(forHTTPHeaderField: AuthenticationMode.autologin.header)
                    let pin = httpResponse.value(forHTTPHeaderField: AuthenticationMode.pin.header)
                    return (nationName: nationName, autologin: autoLogin, pin: pin)
                }
                
                return (nationName: nationName, autologin: nil, pin: nil)
            }
            .eraseToAnyPublisher()
    }
    
    static func ping(authentication: AuthenticationPair) -> AnyPublisher<Bool, APIError> {
        guard let url = URLBuilder.url(for: authentication.nationName, with: .ping) else { fatalError() }
    
        return authenticatedRequest(using: url, method: .regular(authentication))
            .map { result -> Bool in
                let parser = PingResponseXMLParser(result.data)
                parser.parse()
                return parser.ping
            }
            .eraseToAnyPublisher()
    }
}

extension NationStatesAPI {
    static func answerIssue(_ issue: Issue, option: Option, authentication: AuthenticationPair) -> AnyPublisher<AnsweredIssueResultDTO, APIError> {
        guard let url = URLBuilder.answerIssueUrl(for: authentication.nationName, issue: issue, option: option) else { fatalError() }
        
        return authenticatedRequest(using: url, method: .regular(authentication))
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
    static func fetchIssues(authentication: AuthenticationPair) -> AnyPublisher<FetchIssuesResultDTO, APIError> {
        guard let url = URLBuilder.url(for: authentication.nationName, with: [.issues, .nextissue, .nextissuetime]) else { fatalError() }
        
        return authenticatedRequest(using: url, method: .regular(authentication))
            .map({ result -> FetchIssuesResultDTO in
                let parser = IssuesResponseXMLParser(result.data)
                parser.parse()
                return FetchIssuesResultDTO(issues: parser.issues, timeLeftForNextIssue: parser.timeLeftForNextIssue, nextIssueDate: parser.nextIssueDate)
            })
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
