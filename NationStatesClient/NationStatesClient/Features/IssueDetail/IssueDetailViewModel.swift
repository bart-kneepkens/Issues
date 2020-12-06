//
//  IssueDetailViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import Combine
import Foundation
import WidgetKit

class IssueDetailViewModel: ObservableObject {
    var issue: Issue
    @Published var answeredIssueResult: AnsweredIssueResult? {
        didSet {
            if let result = self.answeredIssueResult {
                self.issueContainer?.didCompleteIssue(.init(issue: self.issue, result: result))
            }
        }
    }
    @Published var isAnsweringIssue = false
    @Published var error: APIError?
    @Published var nationName: String
    
    private(set) var provider: IssueProvider?
    private(set) var issueContainer: IssueContainer?
    private var cancellables: [Cancellable?]? = []
    
    init(_ issue: Issue, provider: IssueProvider, nationName: String, issueContainer: IssueContainer) {
        self.issue = issue
        self.provider = provider
        self.nationName = nationName
        self.issueContainer = issueContainer
    }
    
    init(completedIssue: CompletedIssue, nationName: String) {
        self.issue = completedIssue.issue
        self.nationName = nationName
        self.answeredIssueResult = completedIssue.result
    }
    
    func answer(with option: Option) {
        self.isAnsweringIssue = true
        self.cancellables?.append(
            provider?.answerIssue(issue: self.issue, option: option)
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveCompletion: { completion in
                    self.isAnsweringIssue = false
                    
                    switch completion {
                    case .finished: WidgetCenter.shared.reloadAllTimelines()
                    default: break
                    }
                })
                .catch({ error -> AnyPublisher<AnsweredIssueResult?, Never> in
                    self.error = error
                    return Just(nil).eraseToAnyPublisher()
                })
                .assign(to: \.answeredIssueResult, on: self)
        )
    }
}
