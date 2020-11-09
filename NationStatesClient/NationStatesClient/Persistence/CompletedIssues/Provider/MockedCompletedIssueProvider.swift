//
//  MockedCompletedIssueProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 07/11/2020.
//

import Foundation
import Combine

#if DEBUG
class MockedCompletedIssueProvider: CompletedIssueProvider {
    var completedIssues: [CompletedIssue] = [
        CompletedIssue(issue: Issue.filler, result: .filler)
    ]
    
    func fetchCompletedIssues() -> AnyPublisher<[CompletedIssue], Error> {
        Just(self.completedIssues)
            .delay(for: 3, scheduler: DispatchQueue.main)
            .mapError { failure -> Error in }
            .eraseToAnyPublisher()
    }
    
    func storeCompletedIssue(_ completed: CompletedIssue) {
        self.completedIssues.append(completed)
    }
}
#endif
