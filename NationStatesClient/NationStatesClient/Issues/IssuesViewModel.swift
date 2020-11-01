//
//  IssuesViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import Foundation
import Combine

class IssuesViewModel: ObservableObject {
    var issues: [Issue] = []
    var error: APIError? = nil
    var isFetchingIssues: Bool = false
    
    private(set) var provider: IssueProvider
    private(set) var authenticationContainer: AuthenticationContainer
    
    private var cancellables: [Cancellable] = []
    
    init(provider: IssueProvider, authenticationContainer: AuthenticationContainer) {
        self.provider = provider
        self.authenticationContainer = authenticationContainer
    }
    
    func initialize() {
        isFetchingIssues = true
        cancellables.append(
            self.provider.fetchIssues()
                .receive(on: DispatchQueue.main)
                .catch({ error -> AnyPublisher<[Issue], Never> in
                    self.error = error
                    return Just([]).eraseToAnyPublisher()
                })
                .handleEvents(receiveCompletion: { comp in
                    self.isFetchingIssues = false
                    self.objectWillChange.send()
                })
                .assign(to: \.issues, on: self)
        )
    }
}

extension IssuesViewModel {
    var nationViewModel: NationViewModel {
        return .init(authenticationContainer: self.authenticationContainer)
    }
    
    func issueDetailViewModel(issue: Issue) -> IssueDetailViewModel {
        return .init(issue, provider: self.provider, nationName: self.authenticationContainer.pair?.nationName ?? "")
    }
}
