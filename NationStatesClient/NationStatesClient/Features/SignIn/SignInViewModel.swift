//
//  SignInViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import Foundation
import Combine

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
    @Published var nationName: String = ""
    @Published var password: String = ""
    var authenticationSuccessful: Bool = false
    var signInError: Error?
    
    private var cancellable: Cancellable?
    
    func attemptSignIn() {
        self.authenticationContainer.nationName = self.nationName
        self.authenticationContainer.password = self.password
        
        self.signInError = nil
        self.isSigningIn = true
        
        self.cancellable = self.authenticationProvider
            .authenticate(authenticationContainer: self.authenticationContainer)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    self.authenticationContainer.password = "" // Clear password to prevent autologin
                    self.signInError = err
                default: break
                }
                
                self.isSigningIn = false
                self.objectWillChange.send()
            }, receiveValue: { success in
                if success {
                    self.authenticationSuccessful = true
                    self.objectWillChange.send()
                }
            })
    }
    
    var signInButtonDisabled: Bool {
        nationName.isEmpty || password.count < 2 // Yes, this is really the only password requirement on NS
    }
    
    func issuesViewModel() -> IssuesViewModel {
        return .init(provider: self.issueProvider, authenticationContainer: self.authenticationContainer)
    }
}
