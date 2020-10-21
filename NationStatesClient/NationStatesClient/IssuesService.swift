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
    @Published var answeredIssueResult: String = ""
    @Published var anweringIssue = false
    
    @Published var error: APIError?
    
    private var cancellables: [Cancellable] = []
    
    func fetchIssues() {
        guard let nationName = Authentication.shared.nationName else { return }
        self.fetchingIssues = true
        
        self.cancellables.append(
            NationStatesAPI.request(for: [.issues], nation: nationName)
                .handleEvents(receiveCompletion: { _ in
                    self.fetchingIssues = false
                })
                .catch({ (error) -> AnyPublisher<[IssueDTO], Never> in
                    self.error = error
                    return Just([]).eraseToAnyPublisher()
                })
                .map({ dtos -> [Issue] in
                    return dtos.map({ Issue($0) })
                })
                .assign(to: \.issues, on: self)
        )
    }
    
    func answer(issue: Issue, option: Option) {
        self.cancellables.append(
            NationStatesAPI.answerIssue(issue, option: option)
                .handleEvents(receiveCompletion: { completion in
                    self.fetchingIssues = false
                    switch completion {
                    case .finished:
                        self.issues = self.issues.filter({ $0.id != issue.id })
                    default: break
                    }
                })
                .catch({ (error) -> AnyPublisher<String, Never> in
                    self.error = error
                    return Just("").eraseToAnyPublisher()
                })
                .assign(to: \.answeredIssueResult, on: self)
        )
    }
}
