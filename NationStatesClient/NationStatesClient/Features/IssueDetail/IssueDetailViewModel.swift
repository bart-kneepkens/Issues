//
//  IssueDetailViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import Combine
import Foundation
import WidgetKit
import UIKit
import SwiftUI

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
    @Published var currency: String
    
    private(set) var provider: IssueProvider?
    private let nationDetailsProvider: NationDetailsProvider
    private(set) var issueContainer: IssueContainer?
    private var cancellables: [Cancellable?]? = []
    
    init(_ issue: Issue, provider: IssueProvider, nationDetailsProvider: NationDetailsProvider, nationName: String, issueContainer: IssueContainer) {
        self.issue = issue
        self.provider = provider
        self.nationDetailsProvider = nationDetailsProvider
        self.currency = nationDetailsProvider.nationDetails.value?.currency ?? "dollar"
        self.nationName = nationName
        self.issueContainer = issueContainer
    }
    
    init(completedIssue: CompletedIssue, nationDetailsProvider: NationDetailsProvider, nationName: String) {
        self.issue = completedIssue.issue
        self.nationName = nationName
        self.answeredIssueResult = completedIssue.result
        self.nationDetailsProvider = nationDetailsProvider
        self.currency = nationDetailsProvider.nationDetails.value?.currency ?? "dollar"
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
