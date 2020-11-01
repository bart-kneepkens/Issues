//
//  APIIssueProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 27/10/2020.
//

import Foundation
import Combine

class APIIssueProvider: IssueProvider {
    let authenticationContainer: AuthenticationContainer
    
    init(container: AuthenticationContainer) {
        self.authenticationContainer = container
    }
    
    func fetchIssues() -> AnyPublisher<[Issue], APIError> {
        guard let pair = authenticationContainer.pair else {
            return Fail(error: APIError.unauthorized).eraseToAnyPublisher()
        }
        
        return NationStatesAPI
            .fetchIssues(authentication: pair)
            .throttle(for: .seconds(5), scheduler: DispatchQueue.main, latest: false)
            .map { dtos -> [Issue] in
                return dtos.map({ Issue($0) })
            }
            .eraseToAnyPublisher()
    }
    
    func answerIssue(issue: Issue, option: Option) -> AnyPublisher<AnsweredIssueResult?, APIError> {
        guard let pair = authenticationContainer.pair else {
            return Fail(error: APIError.unauthorized).eraseToAnyPublisher()
        }
        
        return NationStatesAPI.answerIssue(issue, option: option, authentication: pair)
            .map({ AnsweredIssueResult(dto: $0 )})
            .eraseToAnyPublisher()
    }
}
