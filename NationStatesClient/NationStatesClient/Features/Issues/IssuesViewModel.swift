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
    
    private var provider: IssueProvider
    private var authenticationContainer: AuthenticationContainer
    private var cancellables: [Cancellable]? = []
    private var shouldFetchPublisher = PassthroughSubject<Bool, Never>()
    private let refreshIssuesTimer = Timer.publish(every: 10, tolerance: 5, on: .main, in: .common).autoconnect()
    
    init(provider: IssueProvider, authenticationContainer: AuthenticationContainer) {
        self.provider = provider
        self.authenticationContainer = authenticationContainer
        self.cancellables?.append(
            self.shouldFetchPublisher
                .throttle(for: .seconds(8), scheduler: DispatchQueue.main, latest: false)
                .sink { shouldShowProgressIndicator in self.fetchIssues(shouldShowProgressIndicator) }
        )
        
        self.cancellables?.append(refreshIssuesTimer.sink(receiveValue: { _ in
            self.shouldFetchPublisher.send(false)
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
    }
}

extension IssuesViewModel {
    var nationViewModel: NationViewModel {
        return .init(authenticationContainer: self.authenticationContainer)
    }
    
    func issueDetailViewModel(issue: Issue) -> IssueDetailViewModel {
        return .init(issue, provider: self.provider, nationName: self.authenticationContainer.nationName, issueContainer: self)
    }
    
    func issueDetailViewModel(completedIssue: CompletedIssue) -> IssueDetailViewModel {
        .init(completedIssue: completedIssue, provider: self.provider, nationName: self.authenticationContainer.nationName, issueContainer: self)
    }
}
