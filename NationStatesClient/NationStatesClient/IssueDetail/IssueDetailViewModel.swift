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
    @Published var answeredIssueResult: String?
    
    private(set) var service: IssuesService
    private var cancellable: Cancellable?
    
    init(_ issue: Issue, service: IssuesService) {
        _issue = Published(initialValue: issue)
        self.service = service
        
        self.cancellable = service.$answeredIssueResult
            .receive(on: DispatchQueue.main)
            .assign(to: \.answeredIssueResult, on: self)
    }
    
    func answer(with option: Option) {
        self.service.answer(issue: issue, option: option)
    }
}
