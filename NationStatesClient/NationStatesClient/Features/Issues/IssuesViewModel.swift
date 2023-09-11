//
//  IssuesViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import Foundation
import Combine
import StoreKit

protocol IssueContainer {
    func didCompleteIssue(_ completedIssue: CompletedIssue)
}

class IssuesViewModel: ObservableObject {
    var fetchIssuesResult: FetchIssuesResult? {
        didSet {
            if let result = self.fetchIssuesResult {
                self.issues = result.issues
                
                // TODO: Put this deeplink synchronization somewhere else, it really doesn't belong in this setter.
                if let deeplinkId = self.deeplinkedIssueId, let issue = result.issues.first(where: { $0.id == deeplinkId }) {
                    self.deeplinkedIssue = issue
                    self.deeplinkedIssueId = nil
                }
                
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
                
                setRefetchTimer(at: result.nextIssueDate)
            }
        }
    }
    var error: APIError? = nil
    var isFetchingIssues: Bool = false
    var issues: [Issue] = []
    var completedIssues: [CompletedIssue] = []
    
    @Published var deeplinkedIssue: Issue?
    
    private let persistentContainer: CompletedIssueProvider
    private let provider: IssueProvider
    private let authenticationContainer: AuthenticationContainer
    
    private var cancellables = Set<AnyCancellable>()
    private var shouldFetchPublisher = PassthroughSubject<Bool, Never>()
    private var refetchTimer: Timer?
    private var didJustAnswerAnIssue = false
    private var deeplinkedIssueId: Int?
    private var justAnsweredIssueId: Int?
    
    init(provider: IssueProvider, completedIssueProvider: CompletedIssueProvider, authenticationContainer: AuthenticationContainer) {
        self.provider = provider
        self.authenticationContainer = authenticationContainer
        self.persistentContainer = completedIssueProvider
        
        self.shouldFetchPublisher
            .throttle(for: .seconds(10), scheduler: DispatchQueue.main, latest: false)
            .sink { [weak self] shouldShowProgressIndicator in
                self?.fetchIssues(shouldShowProgressIndicator)
                self?.requestAppStoreReviewIfNeeded()
            }
            .store(in: &cancellables)
        
        
        persistentContainer.fetchCompletedIssues()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] completedIssues in
                    self?.completedIssues = completedIssues
                }
            )
            .store(in: &cancellables)
        
        
        authenticationContainer
            .$hasSignedOut
            .filter({ $0 })
            .sink(receiveValue: { [weak self] _ in
                self?.refetchTimer?.invalidate()
                self?.refetchTimer = nil
            })
            .store(in: &cancellables)
    }
    
   
    @objc func updateIssues() {
        if let justAnsweredIssueId {
            self.issues = self.issues.filter({ $0.id != justAnsweredIssueId }) // Remove from currently visible issues
            self.justAnsweredIssueId = nil
            self.objectWillChange.send()
        }
        self.shouldFetchPublisher.send(true)
    }
    
    func refreshIssuesManually() async throws {
        let fetchResult = try await provider.fetchIssuesAsync()
        self.fetchIssuesResult = fetchResult
    }
    
    func signOut() {
        self.authenticationContainer.signOut()
    }
    
    func requestAppStoreReviewIfNeeded() {
        // Ask for a rating no earlier than after answering 4 issues, but only after just answering an issue.
        if didJustAnswerAnIssue && self.completedIssues.count.isMultiple(of: 4) { // Fancy modulo aye?
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                // It's OK to call this multiple times - it will not be presented in case the user already gave a rating.
                SKStoreReviewController.requestReview(in: scene)
                didJustAnswerAnIssue = false
            }
        }
    }
    
    func didReceiveDeeplink(with issueId: Int) {
        if let issue = issues.first(where: { $0.id == issueId }) {
            self.deeplinkedIssue = issue
        } else {
            self.deeplinkedIssueId = issueId
        }
    }
    
    private func fetchIssues(_ showProgress: Bool) {
        guard !self.authenticationContainer.nationName.isEmpty else { return } // TODO: put this check at another level - so no outstanding requests can be done after sign out
        
        if showProgress {
            self.isFetchingIssues = true
            self.objectWillChange.send()
        }
        
        self.provider.fetchIssues()
            .receive(on: DispatchQueue.main)
            .catch({ [weak self] error -> AnyPublisher<FetchIssuesResult?, Never> in
                self?.error = error
                return Just(nil).eraseToAnyPublisher()
            })
            .handleEvents(receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    switch completion {
                    case .finished:
                        self.error = nil
                    }
                    
                    if showProgress {
                        self.isFetchingIssues = false
                        self.objectWillChange.send()
                    }
            })
            .assign(to: \.fetchIssuesResult, onWeak: self)
            .store(in: &cancellables)
    }
    
    private func setRefetchTimer(at date: Date) {
        self.refetchTimer?.invalidate()
        
        let timer = Timer(fireAt: date.advanced(by: 5), interval: 0, target: self, selector: #selector(updateIssues), userInfo: nil, repeats: false)
        
        RunLoop.main.add(timer, forMode: .default)
        
        self.refetchTimer = timer
    }
}

extension IssuesViewModel: IssueContainer {
    func didCompleteIssue(_ completedIssue: CompletedIssue) {
        self.completedIssues.append(completedIssue)
        self.persistentContainer.storeCompletedIssue(completedIssue)
        self.didJustAnswerAnIssue = true
        self.justAnsweredIssueId = completedIssue.issue.id
    }
}
