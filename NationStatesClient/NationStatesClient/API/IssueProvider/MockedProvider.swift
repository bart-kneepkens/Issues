//
//  MockedProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/10/2020.
//

import Foundation
import Combine

#if DEBUG
class MockedProvider: IssueProvider {
    let issues: [Issue]
    let answerResult: AnsweredIssueResult
    let delay: Int
    
    init(issues: [Issue] = [Issue.filler],
         answerResult: AnsweredIssueResult = AnsweredIssueResult.filler,
         delay: Int = 1
    ) {
        self.issues = issues
        self.answerResult = answerResult
        self.delay = delay
    }
    
    func fetchIssues() -> AnyPublisher<[Issue], APIError> {
        return Just(self.issues)
            .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
            .mapError({ _ in APIError.conflict })
            .eraseToAnyPublisher()
    }
    
    func answerIssue(issue: Issue, option: Option) -> AnyPublisher<AnsweredIssueResult?, APIError> {
        return Just(self.answerResult)
            .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
            .mapError({ _ in APIError.conflict })
            .eraseToAnyPublisher()
    }
}
#endif
