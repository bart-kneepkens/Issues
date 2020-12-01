//
//  IssuesViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import Foundation
import Combine

enum IssuesListType {
    case current, past
}

protocol IssueContainer {
    func didCompleteIssue(_ completedIssue: CompletedIssue)
}

class IssuesViewModel: ObservableObject {
    var fetchIssuesResult: FetchIssuesResult? {
        didSet {
            if let result = self.fetchIssuesResult {
                self.issues = result.issues
            }
        }
    }
    var error: APIError? = nil
    var isFetchingIssues: Bool = false
    var issues: [Issue] = []
    var completedIssues: [CompletedIssue] = []
    
    @Published var selectedIssuesList: IssuesListType = .current
    
    private let persistentContainer: CompletedIssueProvider
    private var provider: IssueProvider
    private let nationDetailsProvider: NationDetailsProvider
    private var authenticationContainer: AuthenticationContainer
    private var cancellables: [Cancellable]? = []
    private var shouldFetchPublisher = PassthroughSubject<Bool, Never>()
    private let refreshIssuesTimer = Timer.publish(every: 20, tolerance: 5, on: .main, in: .common).autoconnect()
    
    init(provider: IssueProvider, nationDetailsProvider: NationDetailsProvider, authenticationContainer: AuthenticationContainer) {
        self.provider = provider
        self.authenticationContainer = authenticationContainer
        self.nationDetailsProvider = nationDetailsProvider
        self.persistentContainer = PersisentCompletedIssueProvider()
        self.cancellables?.append(
            self.shouldFetchPublisher
                .throttle(for: .seconds(8), scheduler: DispatchQueue.main, latest: false)
                .sink { shouldShowProgressIndicator in self.fetchIssues(shouldShowProgressIndicator)}
        )
        
        self.cancellables?.append(refreshIssuesTimer.sink(receiveValue: { _ in self.shouldFetchPublisher.send(false) }))
        
        self.cancellables?.append(persistentContainer.fetchCompletedIssues().sink(receiveCompletion: { completion in
            
        }, receiveValue: { compIssues in
            self.completedIssues = compIssues
        }))
        
        // Disable the refresh timer when signed out
        self.cancellables?.append(authenticationContainer.$hasSignedOut.sink(receiveValue: { signedOut in
            if signedOut {
                self.refreshIssuesTimer.upstream.connect().cancel()
            }
        }))
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
                .handleEvents(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        self.error = nil
                    }
                    
                    if showProgress {
                        self.isFetchingIssues = false
                    }
                    self.objectWillChange.send()
                })
                .assign(to: \.fetchIssuesResult, on: self)
        )
    }
}

extension IssuesViewModel: IssueContainer {
    func didCompleteIssue(_ completedIssue: CompletedIssue) {
        self.issues = self.issues.filter({ $0.id != completedIssue.issue.id }) // Remove from current issues
        self.completedIssues.append(completedIssue)
        self.persistentContainer.storeCompletedIssue(completedIssue)
        self.objectWillChange.send()
    }
}

extension IssuesViewModel {
    var nationViewModel: NationViewModel {
        return .init(provider: self.nationDetailsProvider, authenticationContainer: self.authenticationContainer)
    }
    
    func issueDetailViewModel(issue: Issue) -> IssueDetailViewModel {
        return .init(issue, provider: self.provider, nationName: self.authenticationContainer.nationName, issueContainer: self)
    }
    
    func issueDetailViewModel(completedIssue: CompletedIssue) -> IssueDetailViewModel {
        .init(completedIssue: completedIssue, nationName: self.authenticationContainer.nationName)
    }
}
