//
//  IssuesService.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/10/2020.
//

import Foundation
import Combine

protocol IssuesProvider {
    func fetchIssues()
    func answer(issue: Issue, option: Option)
}

class IssuesService: IssuesProvider, ObservableObject {
    
    static let shared = IssuesService()
    
    @Published var issues: [Issue] = []
    @Published var answeredIssueResult: String?
    
    func fetchIssues() {
        guard let nationName = Authorization.shared.nationName else { return }
        NationStatesAPI.request(for: [.issues], nation: nationName) { result in
            switch result {
            case .success(let response): self.issues = response.map({ Issue($0) })
            default: break
            }
        }
    }
    
    func answer(issue: Issue, option: Option) {
        NationStatesAPI.answerIssue(issue, option: option) { result in
            switch result {
            case .success(let desc): self.answeredIssueResult = desc
            default: break
            }
        }
    }
}
