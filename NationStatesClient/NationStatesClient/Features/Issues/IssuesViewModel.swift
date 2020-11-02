//
//  IssuesViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import Foundation
import Combine

class IssuesViewModel: ObservableObject {
    var fetchIssuesResult: FetchIssuesResult?
    var error: APIError? = nil
    var isFetchingIssues: Bool = false
    
    private(set) var provider: IssueProvider
    private(set) var authenticationContainer: AuthenticationContainer
    
    private var cancellables: [Cancellable] = []
    
    init(provider: IssueProvider, authenticationContainer: AuthenticationContainer) {
        self.provider = provider
        self.authenticationContainer = authenticationContainer
    }
    
    var issues: [Issue] {
        get {
            return fetchIssuesResult?.issues ?? []
        }
    }
    
    func initialize() {
        isFetchingIssues = true
        self.objectWillChange.send()
        cancellables.append(
            self.provider.fetchIssues()
                .receive(on: DispatchQueue.main)
                .catch({ error -> AnyPublisher<FetchIssuesResult?, Never> in
                    self.error = error
                    return Just(nil).eraseToAnyPublisher()
                })
                .handleEvents(receiveCompletion: { comp in
                    self.isFetchingIssues = false
                    self.objectWillChange.send()
                })
                .assign(to: \.fetchIssuesResult, on: self)
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
