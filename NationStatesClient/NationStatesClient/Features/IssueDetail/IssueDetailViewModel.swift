//
//  IssueDetailViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import Combine
import Foundation

class IssueDetailViewModel: ObservableObject {
    var issue: Issue
    @Published var answeredIssueResult: AnsweredIssueResult?
    @Published var isAnsweringIssue = false
    @Published var error: APIError?
    @Published var nationName: String
    
    private(set) var provider: IssueProvider
    private var cancellables: [Cancellable?] = []
    
    init(_ issue: Issue, provider: IssueProvider, nationName: String) {
        self.issue = issue
        self.provider = provider
        self.nationName = nationName
    }
    
    func answer(with option: Option) {
        self.isAnsweringIssue = true
        self.cancellables.append(
            provider.answerIssue(issue: self.issue, option: option)
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveCompletion: { _ in
                    self.isAnsweringIssue = false
                })
                .catch({ error -> AnyPublisher<AnsweredIssueResult?, Never> in
                    self.error = error
                    return Just(nil).eraseToAnyPublisher()
                })
                .assign(to: \.answeredIssueResult, on: self)
        )
    }
}
