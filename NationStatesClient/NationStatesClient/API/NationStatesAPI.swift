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
    
    case category
    case motto
    case type
    case name
    case fullname
    case freedom
    case flag
    case census
    
    case region
    case influence
    case population
    case currency
    case animal
    
    case gavote
    case scvote
}

enum WorldAssemblyShard: String {
    case resolution
    case lastResolution
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
    case timedOut
    case unknown(code: Int)
    case nationNotFound
    case nationStatesOutage
}

typealias DataResponse = (data: Data, response: URLResponse)

struct NationStatesAPI {
    private init() {}
    
    private static func authenticatedRequest(using url: URL,
                                authenticationContainer: AuthenticationContainer,
                                session: NetworkSession = URLSession.shared
    ) -> AnyPublisher<DataResponse, APIError> {
        return AuthenticatedAPIRequest(url: url, authenticationContainer: authenticationContainer).publisher
    }
    
    private static func authenticatedRequestAsync(using url: URL,
                                                  authenticationContainer: AuthenticationContainer,
                                                  session: NetworkSession = URLSession.shared) async throws -> DataResponse {
        try await AuthenticatedAPIRequest(url: url, authenticationContainer: authenticationContainer).response
        
    }
    
    private static func request(using url: URL,
                                authenticationContainer: AuthenticationContainer,
                                session: NetworkSession = URLSession.shared
    ) -> AnyPublisher<DataResponse, APIError> {
        return APIRequest(url: url, authenticationContainer: authenticationContainer).publisher
    }
    
    private static func cookieAuthenticatedWebRequest(using url: URL, authenticationContainer: AuthenticationContainer) -> URLRequest? {
        var request = URLRequest(url: url)
        var cookieString = ""
        
        if let pin = authenticationContainer.pin {
            cookieString.append("pin=\(pin)")
        }
        if let autologin = authenticationContainer.autologin {
            cookieString.append(";autologin=\(autologin)")
        }
        
        if cookieString.isEmpty {
            print("No authentication headers found, thus can not authenticate request with cookie")
            return nil
        }
        
        request.addValue(cookieString, forHTTPHeaderField: "Cookie")
        request.setupUserAgentHeader(nationName: authenticationContainer.nationName)
        
        request.httpShouldHandleCookies = true
        
        return request
    }
    
    static func ping(authenticationContainer: AuthenticationContainer, session: NetworkSession = URLSession.shared) -> AnyPublisher<Bool, APIError> {
        guard let url = URLBuilder.url(for: authenticationContainer.nationName, with: .ping) else {
            return Just(false).mapError({ _ in APIError.notConnected }).eraseToAnyPublisher()
        }
        
        return authenticatedRequest(using: url,
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

// MARK: - Issues
extension NationStatesAPI {
    static func answerIssue(_ issue: Issue, option: Option, authenticationContainer: AuthenticationContainer) -> AnyPublisher<AnsweredIssueResultDTO, APIError> {
        guard let url = URLBuilder.answerIssueUrl(for: authenticationContainer.nationName, issue: issue, option: option) else {
            return Just(AnsweredIssueResultDTO()).mapError({ _ in APIError.notConnected }).eraseToAnyPublisher()
        }
        
        return authenticatedRequest(using: url, authenticationContainer: authenticationContainer)
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
    
    static func fetchIssues(authenticationContainer: AuthenticationContainer) -> AnyPublisher<FetchIssuesResultDTO, APIError> {
        guard let url = URLBuilder.url(for: authenticationContainer.nationName, with: [.issues, .nextissue, .nextissuetime]) else {
            return Just(FetchIssuesResultDTO()).mapError({ _ in APIError.notConnected }).eraseToAnyPublisher()
        }
        
        return authenticatedRequest(using: url, authenticationContainer: authenticationContainer)
            .map({ result -> FetchIssuesResultDTO in
                let parser = IssuesResponseXMLParser(result.data)
                parser.parse()
                return FetchIssuesResultDTO(issues: parser.issues, timeLeftForNextIssue: parser.timeLeftForNextIssue, nextIssueDate: parser.nextIssueDate)
            })
            .eraseToAnyPublisher()
    }
    
    static func fetchIssuesAsync(authenticationContainer: AuthenticationContainer) async throws -> FetchIssuesResultDTO {
        guard let url = URLBuilder.url(for: authenticationContainer.nationName, with: [.issues, .nextissue, .nextissuetime]) else {
            throw APIError.notConnected
        }
        
        let dataResponse = try await authenticatedRequestAsync(using: url, authenticationContainer: authenticationContainer)
        let parser = IssuesResponseXMLParser(dataResponse.data)
        parser.parse()
        return FetchIssuesResultDTO(issues: parser.issues, timeLeftForNextIssue: parser.timeLeftForNextIssue, nextIssueDate: parser.nextIssueDate)
        
    }
}

// MARK: - Image
extension NationStatesAPI {
    static func fetchImageData(_ name: String, completionHandler: @escaping (Result<Data?, APIError>) -> Void) {
        guard let url = URLBuilder.imageUrl(for: name) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            completionHandler(.success(data))
        }
    }
}

// MARK: - Nation Details
extension NationStatesAPI {
    static func fetchNationDetails(authenticationContainer: AuthenticationContainer, for nationName: String) -> AnyPublisher<NationDTO, APIError> {
        guard let url = URLBuilder.nationDetailsUrl(for: nationName) else {
            return Just(NationDTO()).mapError({ _ in APIError.notConnected }).eraseToAnyPublisher()
        }
        
        return request(using: url, authenticationContainer: authenticationContainer).map { result -> NationDTO in
            let parser = NationDetailsResponseXMLParser(result.data)
            parser.parse()
            return parser.nationDTO
        }
        .mapError({ apiError -> APIError in
            switch apiError {
            case .notFound:
                return .nationNotFound
            default:
                return apiError
            }
        })
        .eraseToAnyPublisher()
    }
}

// MARK: - World Assembly
extension NationStatesAPI {
    static func fetchResolution(authenticationContainer: AuthenticationContainer, worldAssembly: WorldAssembly) -> AnyPublisher<ResolutionDTO, APIError> {
        guard let url = URLBuilder.worldAssemblyURL(for: worldAssembly, with: [.resolution]) else {
            return Just(ResolutionDTO()).mapError({ _ in APIError.notConnected }).eraseToAnyPublisher()
        }
        
        return authenticatedRequest(using: url, authenticationContainer: authenticationContainer).map { result -> ResolutionDTO in
            let parser = ResolutionResponseXMLParser(result.data)
            parser.parse()
            return parser.resolution
        }
        .eraseToAnyPublisher()
    }
}

extension NationStatesAPI {
    static func fetchResolutionInformation(for worldAssembly: WorldAssembly, authenticationContainer: AuthenticationContainer) -> AnyPublisher<ResolutionInformation?, Never> {
        
        guard let url = worldAssembly == .general ? URLBuilder.generalAssemblyFormURL : URLBuilder.securityCouncilFormURL,
              let request = self.cookieAuthenticatedWebRequest(using: url, authenticationContainer: authenticationContainer) else {
            return Just(nil).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .map { response -> ResolutionInformation? in
                guard let responseString = String(data: response.data, encoding: .windowsCP1252) else { return nil }
                let parser = WorldAssemblyHTMLParser(responseString)
                return ResolutionInformation(localId: parser.localId, textHTML: parser.htmlText)
            }
            .catch { failure -> AnyPublisher<ResolutionInformation?, Never> in
                return Just(nil).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    static func vote(authenticationContainer: AuthenticationContainer, worldAssembly: WorldAssembly, localId: String, option: VoteOption) -> AnyPublisher<VoteOption?, Never> {
        let formUrl = worldAssembly == .general ? URLBuilder.generalAssemblyFormURL : URLBuilder.securityCouncilFormURL
        
        guard let url = formUrl,
              var request = self.cookieAuthenticatedWebRequest(using: url, authenticationContainer: authenticationContainer) else {
            return Just(nil).eraseToAnyPublisher()
        }
        
        request.httpMethod = "POST"
        request.httpBody = "localid=\(localId)&vote=\(option.httpValue)".data(using: .utf8)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { response -> VoteOption? in
                if let httpResponse = response.response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        return option
                    }
                }
                return nil
            }
            .catch({ _ in Just(nil).eraseToAnyPublisher() })
            .eraseToAnyPublisher()
    }
}
