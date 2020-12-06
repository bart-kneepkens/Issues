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
    private var refreshIssuesTimerCancellable: Cancellable?
    
    init(provider: IssueProvider, nationDetailsProvider: NationDetailsProvider, authenticationContainer: AuthenticationContainer) {
        self.provider = provider
        self.authenticationContainer = authenticationContainer
        self.nationDetailsProvider = nationDetailsProvider
        self.persistentContainer = PersisentCompletedIssueProvider()
        self.cancellables?.append(
            self.shouldFetchPublisher
                .throttle(for: .seconds(25), scheduler: DispatchQueue.main, latest: false)
                .sink { [weak self] shouldShowProgressIndicator  in
                    self?.fetchIssues(shouldShowProgressIndicator)
                }
        )
        
        self.cancellables?.append(
            persistentContainer.fetchCompletedIssues()
                .sink(receiveCompletion: { _ in
            
        }, receiveValue: { [weak self] compIssues in
            guard let strongSelf = self else { return }
            strongSelf.completedIssues = compIssues
        }))
        
        self.cancellables?.append(
            authenticationContainer.$hasSignedOut.sink(receiveValue: { signedOut in
                if signedOut {
                    self.refreshIssuesTimerCancellable = nil
                }
            })
        )
        
    }
    
    func startRefreshingTimer() {
        if self.refreshIssuesTimerCancellable == nil {
            // Timer to refresh issues periodically and quietly
            self.refreshIssuesTimerCancellable = Timer.publish(every: 20, tolerance: 5, on: .main, in: .default)
                .autoconnect()
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] _ in
                    print("timer")
                    self?.shouldFetchPublisher.send(false)
                })
        }
    }
    
    func startFetchingIssues() {
        self.shouldFetchPublisher.send(true)
    }
    
    func signOut() {
        self.authenticationContainer.signOut()
    }
    
    private func fetchIssues(_ showProgress: Bool) {
        guard !self.authenticationContainer.nationName.isEmpty else { return } // TODO: put this check at another level - so no outstanding requests can be done after sign out
        
        if showProgress {
            self.isFetchingIssues = true
            self.objectWillChange.send()
        }
        
        self.cancellables?.append(
            self.provider.fetchIssues()
                .receive(on: DispatchQueue.main)
                .catch({ [weak self] error -> AnyPublisher<FetchIssuesResult?, Never> in
                    self?.error = error
                    return Just(nil).eraseToAnyPublisher()
                })
                .handleEvents(receiveCompletion: { [weak self] completion in
                    guard let strongSelf = self else { return }
                    switch completion {
                    case .finished:
                        strongSelf.error = nil
                    }
                    
                    if showProgress {
                        strongSelf.isFetchingIssues = false
                    }
                    strongSelf.objectWillChange.send()
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
