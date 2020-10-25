//
//  IssueDetailViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import Combine
import Foundation

class IssueDetailViewModel: ObservableObject {
    @Published var issue: Issue
    @Published var answeredIssueResponse: AnswerIssueResponse?
    @Published var answeringIssue = false
    
    private(set) var service: IssuesService
    private var cancellables: [Cancellable?] = []
    
    init(_ issue: Issue, service: IssuesService) {
        _issue = Published(initialValue: issue)
        self.service = service
        
        self.cancellables.append(
            service.$answerIssueResponse
                .receive(on: DispatchQueue.main)
                .assign(to: \.answeredIssueResponse, on: self)
        )
        
        self.cancellables.append(
            service.$anweringIssue
                .receive(on: DispatchQueue.main)
                .assign(to: \.answeringIssue, on: self)
        )
    }
    
    func answer(with option: Option) {
        self.service.answer(issue: issue, option: option)
    }
}
