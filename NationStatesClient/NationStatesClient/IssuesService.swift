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
    
    func fetchIssues() {
        guard let nationName = Authorization.shared.nationName else { return }
        NationStates.request(for: [.issues], nation: nationName) { result in
            switch result {
            case .success(let response): self.issues = response.map({ Issue($0) })
            default: break
            }
        }
    }
    
    func answer(issue: Issue, option: Option) {
        
    }
}
