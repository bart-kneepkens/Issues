//
//  ContentViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 01/11/2020.
//

import Foundation
import Combine

enum ContentViewModelState {
    case signingIn
    case signedIn
    case initial
}

class ContentViewModel: ObservableObject {
    @Published var state: ContentViewModelState = .initial
    
    let issueProvider: IssueProvider
    let authenticationProvider: AuthenticationProvider
    
    private let authenticationContainer: AuthenticationContainer
    private var cancellables: [Cancellable] = []
    
    init() {
        self.authenticationContainer = AuthenticationContainer()
        self.issueProvider = APIIssueProvider(container: self.authenticationContainer)
        self.authenticationProvider = APIAuthenticationProvider(authenticationContainer: self.authenticationContainer)
        
        self.cancellables.append(self.authenticationContainer.$pair.sink { pair in
            if pair == nil {
                self.state = .initial
            }
        })
    }
    
    func onAppear() {
        guard self.authenticationContainer.canPerformSilentLogin else { return }
        
        self.state = .signingIn
        
        // Attempt a silent log in
        self.cancellables.append(
            self.authenticationProvider.authenticate().sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(_): self.state = .initial
                }
            }, receiveValue: { success in
                if success {
                    self.state = .signedIn
                }
            })
        )
    }
}

extension ContentViewModel {
    var issuesViewModel: IssuesViewModel {
        return IssuesViewModel(provider: self.issueProvider, authenticationContainer: self.authenticationContainer)
    }
    
    var signInViewModel: SignInViewModel {
        return SignInViewModel(issueProvider: self.issueProvider,
                               authenticationProvider: self.authenticationProvider,
                               authenticationContainer: self.authenticationContainer)
    }
}