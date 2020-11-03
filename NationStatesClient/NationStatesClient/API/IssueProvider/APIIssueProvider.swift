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
            .map({ FetchIssuesResult($0) })
            .throttle(for: .seconds(5), scheduler: DispatchQueue.main, latest: false)
            .eraseToAnyPublisher()
    }
    
    func answerIssue(issue: Issue, option: Option) -> AnyPublisher<AnsweredIssueResult?, APIError> {
        return NationStatesAPI.answerIssue(issue, option: option, authenticationContainer: authenticationContainer)
            .map({ AnsweredIssueResult(dto: $0 )})
            .eraseToAnyPublisher()
    }
}
