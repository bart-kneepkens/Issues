//
//  IssuesService.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/10/2020.
//

import Foundation
import Combine

class IssuesService: ObservableObject {
    @Published var fetchingIssues = false
    @Published var issues: [Issue] = []
    @Published var answeredIssueResult: String?
    @Published var anweringIssue = false
    
    func fetchIssues() {
        guard let nationName = Authentication.shared.nationName else { return }
        self.fetchingIssues = true
        
        NationStatesAPI.request(for: [.issues], nation: nationName) { result in
            self.fetchingIssues = false
            switch result {
            case .success(let response):
                self.issues = response.map({ Issue($0) })
            default: break
            }
        }
    }
    
    func answer(issue: Issue, option: Option) {
        self.anweringIssue = true
        NationStatesAPI.answerIssue(issue, option: option) { result in
            self.anweringIssue = false
            switch result {
            case .success(let desc):
                self.answeredIssueResult = "\(desc.prefix(1).capitalized)\(desc.dropFirst())"
                self.issues = self.issues.filter({ $0.id != issue.id })
            default: break
            }
        }
    }
}
