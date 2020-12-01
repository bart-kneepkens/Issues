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
    
    func fetchIssues() -> AnyPublisher<FetchIssuesResult?, APIError> {
        return NationStatesAPI
            .fetchIssues(authenticationContainer: authenticationContainer)
            .map({ FetchIssuesResult(from: $0) })
            .eraseToAnyPublisher()
    }
    
    func answerIssue(issue: Issue, option: Option) -> AnyPublisher<AnsweredIssueResult?, APIError> {
        return NationStatesAPI.answerIssue(issue, option: option, authenticationContainer: authenticationContainer)
            .map({ AnsweredIssueResult(from: $0 )})
            .eraseToAnyPublisher()
    }
}
