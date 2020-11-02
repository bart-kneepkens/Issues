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
    
    private var shouldFetchPublisher = PassthroughSubject<Bool, Never>()
    
    init(provider: IssueProvider, authenticationContainer: AuthenticationContainer) {
        self.provider = provider
        self.authenticationContainer = authenticationContainer
        self.cancellables.append(
            shouldFetchPublisher
                .throttle(for: .seconds(10), scheduler: DispatchQueue.main, latest: false)
                .sink { _ in self.fetchIssues() }
        )
    }
    
    var issues: [Issue] {
        get {
            return fetchIssuesResult?.issues ?? []
        }
    }
    
    func startFetchingIssues() {
        self.shouldFetchPublisher.send(true)
    }
    
    private func fetchIssues() {
        self.isFetchingIssues = true
        self.objectWillChange.send()
        self.cancellables.append(
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
