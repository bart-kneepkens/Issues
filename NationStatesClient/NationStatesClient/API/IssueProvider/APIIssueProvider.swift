//
//  APIIssueProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 27/10/2020.
//

import Combine

class APIIssueProvider: IssueProvider {
    func fetchIssues() -> AnyPublisher<[Issue], APIError> {
        guard let nationName = Authentication.shared.nationName else {
            return Fail(error: APIError.unauthorized).eraseToAnyPublisher()
        }
        return NationStatesAPI
            .request(for: [.issues], nation: nationName)
            .map { dtos -> [Issue] in
                return dtos.map({ Issue($0) })
            }
            .eraseToAnyPublisher()
    }
    
    func answerIssue(issue: Issue, option: Option) -> AnyPublisher<AnsweredIssueResult?, APIError> {
        return NationStatesAPI.answerIssue(issue, option: option)
            .map({ AnsweredIssueResult(dto: $0 )})
            .eraseToAnyPublisher()
    }
}
