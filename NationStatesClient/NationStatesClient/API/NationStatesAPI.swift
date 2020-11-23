//
//  NationStatesAPI.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/10/2020.
//

import Foundation
import Combine

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
    case notFound // 404
    case rateExceeded // 429
    case notConnected
    case unknown(error: Error)
}

typealias AuthenticationPair = (autologin: String?, pin: String?)

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

struct NationStatesAPI { private init() {}}

typealias DataResponse = (data: Data, response: URLResponse)

protocol NetworkSession {
    func publisher(for request: URLRequest) -> AnyPublisher<DataResponse, URLError>
}

extension URLSession: NetworkSession {
    func publisher(for request: URLRequest) -> AnyPublisher<DataResponse, URLError> {
        return self.dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}

extension NationStatesAPI {
    private static func request(using url: URL,
                                authenticationContainer: AuthenticationContainer,
                                session: NetworkSession = URLSession.shared
    ) -> AnyPublisher<DataResponse, APIError> {
        return APIRequest(url: url, authenticationContainer: authenticationContainer).publisher
    }
    
    static func ping(authenticationContainer: AuthenticationContainer, session: NetworkSession = URLSession.shared) -> AnyPublisher<Bool, APIError> {
        guard let url = URLBuilder.url(for: authenticationContainer.nationName, with: .ping) else { fatalError() }
        
        return request(using: url,
                       authenticationContainer: authenticationContainer,
                       session: session)
            .map { result -> Bool in
                let parser = PingResponseXMLParser(result.data)
                parser.parse()
                return parser.ping
            }
            .eraseToAnyPublisher()
    }
}

extension NationStatesAPI {
    static func answerIssue(_ issue: Issue, option: Option, authenticationContainer: AuthenticationContainer) -> AnyPublisher<AnsweredIssueResultDTO, APIError> {
        guard let url = URLBuilder.answerIssueUrl(for: authenticationContainer.nationName, issue: issue, option: option) else { fatalError() }
        
        return request(using: url, authenticationContainer: authenticationContainer)
            .map { result -> AnsweredIssueResultDTO in
                let parser = AnswerIssueResponseXMLParser(result.data)
                parser.parse()
                return AnsweredIssueResultDTO(resultText: parser.text,
                                              headlines: parser.headlines,
                                              reclassifications: parser.reclassifications,
                                              rankings: parser.rankings,
                                              choice: option)
            }
            .eraseToAnyPublisher()
    }
}

extension NationStatesAPI {
    static func fetchIssues(authenticationContainer: AuthenticationContainer) -> AnyPublisher<FetchIssuesResultDTO, APIError> {
        guard let url = URLBuilder.url(for: authenticationContainer.nationName, with: [.issues, .nextissue, .nextissuetime]) else { fatalError() }
        
        return request(using: url, authenticationContainer: authenticationContainer)
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
