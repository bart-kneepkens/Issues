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
typealias AuthenticationPair = (autologin: String?, pin: String?)

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
                                             authenticationContainer: AuthenticationContainer) -> AnyPublisher<(data: Data, response: URLResponse), APIError> {
        var request = URLRequest(url: url)
        
        request.setupUserAgentHeader(nationName: authenticationContainer.nationName)
        if let authenticationPair = authenticationContainer.pair {
            request.setupAuthenticationHeaders(pair: authenticationPair)
        } else {
            request.setupPasswordAuthenticationHeader(authenticationContainer.password)
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
            .tryCatch({ error -> AnyPublisher<(data: Data, response: URLResponse), APIError> in
                guard let apiError = error as? APIError, let _ = authenticationContainer.pair  else {
                    throw error
                }
                
                switch apiError {
                    case .conflict:
                        print("HTTP call failed with 409, retrying without PIN header")
                        authenticationContainer.pair?.pin = nil
                        return NationStatesAPI.authenticatedRequest(using: url, authenticationContainer: authenticationContainer)
                    case .unauthorized:
                        print("HTTP call failed with 403, retrying without PIN header and autologin")
                        authenticationContainer.pair = nil
                        return NationStatesAPI.authenticatedRequest(using: url, authenticationContainer: authenticationContainer)
                default: throw apiError
                }

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
            .handleEvents(receiveOutput: { output in
                if let httpResponse = output.response as? HTTPURLResponse {
                    var newPair = authenticationContainer.pair
                    
                    if let autoLogin = httpResponse.value(forHTTPHeaderField: AuthenticationMode.autologin.header) {
                        if newPair == nil {
                            newPair = (autologin: autoLogin, pin: nil)
                        }
                        newPair?.autologin = autoLogin
                        print("Set auth AUTOLOGIN")
                    }
                    if let pin = httpResponse.value(forHTTPHeaderField: AuthenticationMode.pin.header) {
                        if newPair == nil {
                            newPair = (autologin: nil, pin: pin)
                        }
                        newPair?.pin = pin
                        print("Set auth PIN")
                    }
                    authenticationContainer.pair = newPair // important to propogate changes
                }
            })
            .eraseToAnyPublisher()
    }
    
    static func ping(authenticationContainer: AuthenticationContainer) -> AnyPublisher<Bool, APIError> {
        guard let url = URLBuilder.url(for: authenticationContainer.nationName, with: .ping) else { fatalError() }
        
        return authenticatedRequest(using: url,
                                    authenticationContainer: authenticationContainer)
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
        
        return authenticatedRequest(using: url, authenticationContainer: authenticationContainer)
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
    static func fetchIssues(authenticationContainer: AuthenticationContainer) -> AnyPublisher<FetchIssuesResultDTO, APIError> {
        guard let url = URLBuilder.url(for: authenticationContainer.nationName, with: [.issues, .nextissue, .nextissuetime]) else { fatalError() }
        
        return authenticatedRequest(using: url, authenticationContainer: authenticationContainer)
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
