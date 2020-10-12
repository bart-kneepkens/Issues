//
//  IssueDetailViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import Combine

class IssueDetailViewModel: ObservableObject {
    @Published var issue: Issue
    
    init(_ issue: Issue) {
        _issue = Published(initialValue: issue)
    }
    
    func answer(with option: Option) {
        // TODO: Call API
        IssuesService.shared.answer(issue: issue, option: option)
    }
}
