//
//  SignInViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import Foundation
import Combine

enum signinState {
    case initial
    case signingIn
    case signinError
    case signedIn
}

class SignInViewModel: ObservableObject {
    private var authenticationProvider: AuthenticationProvider
    private var authenticationContainer: AuthenticationContainer
    private var issueProvider: IssueProvider
    
    init(issueProvider: IssueProvider, authenticationProvider: AuthenticationProvider, authenticationContainer: AuthenticationContainer) {
        self.issueProvider = issueProvider
        self.authenticationProvider = authenticationProvider
        self.authenticationContainer = authenticationContainer
    }
    
    @Published var isSigningIn = false
    var nationName: String = "Elest Adra"
    var password: String = "Cacvu3-cekxed-coxpac"
    var authenticationSuccessful: Bool = false
    var signInError: Error?
    
    private var cancellable: Cancellable?
    
    func attemptSignIn() {
        self.isSigningIn = true
        self.cancellable = self.authenticationProvider
            .authenticate(nationName: nationName, password: password)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    self.signInError = err
                default: break
                }
                
                self.isSigningIn = false
                
                self.objectWillChange.send()
            }, receiveValue: { authenticationPair in
                self.authenticationContainer.pair = authenticationPair
                self.authenticationSuccessful = true
            })
    }
    
    func issuesViewModel() -> IssuesViewModel {
        return .init(provider: self.issueProvider, authenticationContainer: self.authenticationContainer)
    }
}
