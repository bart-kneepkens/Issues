//
//  IssueProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 27/10/2020.
//

import Combine

protocol IssueProvider {
    func fetchIssues() -> AnyPublisher<FetchIssuesResult?, APIError>
    func answerIssue(issue: Issue, option: Option) -> AnyPublisher<AnsweredIssueResult?, APIError>
    func fetchIssuesAsync() async throws -> FetchIssuesResult?
}
