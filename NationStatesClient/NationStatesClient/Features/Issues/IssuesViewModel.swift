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
    
    private var provider: IssueProvider
    private var authenticationContainer: AuthenticationContainer
    private var cancellables: [Cancellable]? = []
    
    private var shouldFetchPublisher = PassthroughSubject<Bool, Never>()
    
    private let refreshIssuesTimer = Timer.publish(every: 30, tolerance: 5, on: .main, in: .common).autoconnect()
    
    init(provider: IssueProvider, authenticationContainer: AuthenticationContainer) {
        self.provider = provider
        self.authenticationContainer = authenticationContainer
        self.cancellables?.append(
            self.shouldFetchPublisher
                .throttle(for: .seconds(10), scheduler: DispatchQueue.main, latest: false)
                .sink { shouldShowProgressIndicator in self.fetchIssues(shouldShowProgressIndicator) }
        )
        
        self.cancellables?.append(refreshIssuesTimer.sink(receiveValue: { _ in
            self.shouldFetchPublisher.send(true)
        }))
    }
    
    var issues: [Issue] {
        get {
            return self.fetchIssuesResult?.issues ?? []
        }
    }
    
    func startFetchingIssues() {
        self.shouldFetchPublisher.send(true)
    }
    
    private func fetchIssues(_ showProgress: Bool) {
        if showProgress {
            self.isFetchingIssues = true
            self.objectWillChange.send()
        }
        
        self.cancellables?.append(
            self.provider.fetchIssues()
                .receive(on: DispatchQueue.main)
                .catch({ error -> AnyPublisher<FetchIssuesResult?, Never> in
                    self.error = error
                    return Just(nil).eraseToAnyPublisher()
                })
                .handleEvents(receiveCompletion: { comp in
                    if showProgress {
                        self.isFetchingIssues = false
                    }
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
