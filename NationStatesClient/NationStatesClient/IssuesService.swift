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
    @Published var anweringIssue = false
    @Published var answerIssueResponse: AnswerIssueResponse?
    
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
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error): self.error = error
                    default: self.anweringIssue = false
                    }
                }, receiveValue: { response in
                    self.answerIssueResponse = response
                })
        )
    }
}
