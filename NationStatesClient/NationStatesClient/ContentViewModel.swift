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
    let nationDetailsProvider: NationDetailsProvider
    
    private let authenticationContainer: AuthenticationContainer
    private var cancellables: [Cancellable] = []
    
    init() {
        self.authenticationContainer = AuthenticationContainer()
        self.issueProvider = APIIssueProvider(container: self.authenticationContainer)
        self.authenticationProvider = APIAuthenticationProvider(authenticationContainer: self.authenticationContainer)
        self.nationDetailsProvider = APINationDetailsProvider(container: self.authenticationContainer)
        
        self.cancellables.append(self.authenticationContainer.$hasSignedOut
                                    .receive(on: DispatchQueue.main)
                                    .sink { signedOut in
                                        if signedOut {
                                            self.state = .initial
                                        }
                                    })
    }
    
    func onAppear() {
        guard self.authenticationContainer.canPerformSilentLogin else { return }
        
        self.state = .signingIn
        
        // Attempt a silent log in
        self.cancellables.append(
            self.authenticationProvider.authenticate(authenticationContainer: self.authenticationContainer)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(_):
                    self.state = .initial
                }
            }, receiveValue: { success in
                if success {
                    self.state = .signedIn
                    self.nationDetailsProvider.fetchDetails()
                }
            })
        )
        
    }
}

extension ContentViewModel {
    var issuesViewModel: IssuesViewModel {
        return IssuesViewModel(provider: self.issueProvider, nationDetailsProvider: self.nationDetailsProvider, authenticationContainer: self.authenticationContainer)
    }
    
    var signInViewModel: SignInViewModel {
        return SignInViewModel(issueProvider: self.issueProvider,
                               authenticationProvider: self.authenticationProvider,
                               authenticationContainer: self.authenticationContainer)
    }
}
