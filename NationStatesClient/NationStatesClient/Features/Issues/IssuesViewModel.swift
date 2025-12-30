//
//  IssuesViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import Foundation
import Combine
import StoreKit
import SwiftUI

protocol IssueContainer {
    func didCompleteIssue(_ completedIssue: CompletedIssue)
}

// TODO: Remove clunky fetching mechanism
// TODO: Separate completely from Past Issues
// TODO: Remove AppStore Review logic
class IssuesViewModel: ObservableObject {
    
    enum State: Equatable {
        case loading
        case loaded([Issue])
        case error(APIError)
    }
    
    @Published var visibleIssueId: Int?
    @Published var state: State = .loading
    
    var fetchIssuesResult: FetchIssuesResult?
    var completedIssues: [CompletedIssue] = []
    
    private let persistentContainer: CompletedIssueProvider
    private let provider: IssueProvider
    private let authenticationContainer: AuthenticationContainer
    
    private var cancellables = Set<AnyCancellable>()
    private var shouldFetchPublisher = PassthroughSubject<Bool, Never>()
    
    private var didJustAnswerAnIssue = false
    private var justAnsweredIssueId: Int?
    
    var deferredLink: DeeplinkHandler.Link?
    
    init(provider: IssueProvider, completedIssueProvider: CompletedIssueProvider, authenticationContainer: AuthenticationContainer) {
        self.provider = provider
        self.authenticationContainer = authenticationContainer
        self.persistentContainer = completedIssueProvider
        
        persistentContainer.fetchCompletedIssues()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] completedIssues in
                    self?.completedIssues = completedIssues
                }
            )
            .store(in: &cancellables)
    }
    
    var nationName: String {
        authenticationContainer.nationName
    }
    
    func resolveIssueDeeplink(link: DeeplinkHandler.Link) throws {
        guard case .issue(let id) = link else { return }
        guard case let .loaded(issues) = state else { return }
        
        if let linkedIssue = issues.first(where: { $0.id == id }) {
            visibleIssueId = linkedIssue.id
        } else {
            throw DeeplinkError.needsToBeDeferred
        }
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
    
    @MainActor
    func fetch() async {
        state = .loading
        do {
            let result = try await provider.fetchIssuesAsync()
            state = .loaded(result?.issues ?? [])
            
            if let deferredLink {
                self.deferredLink = nil
                try? resolveIssueDeeplink(link: deferredLink)
            }
        } catch {
            if let apiError = error as? APIError {
                state = .error(apiError)
            }
        }
    }
}

extension IssuesViewModel: IssueContainer {
    func didCompleteIssue(_ completedIssue: CompletedIssue) {
        self.completedIssues.append(completedIssue)
        self.persistentContainer.storeCompletedIssue(completedIssue)
        self.didJustAnswerAnIssue = true
        guard case let .loaded(issues) = state else { return }
        state = .loaded(issues.filter({ $0 != completedIssue.issue }))
    }
}
