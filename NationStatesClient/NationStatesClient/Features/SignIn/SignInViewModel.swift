//
//  SignInViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import Foundation
import Combine
import WidgetKit

class SignInViewModel: ObservableObject {
    private var authenticationProvider: AuthenticationProvider
    private var authenticationContainer: AuthenticationContainer
    private var contentViewModel: ContentViewModel
    
    init(authenticationProvider: AuthenticationProvider, authenticationContainer: AuthenticationContainer, contentViewModel: ContentViewModel) {
        self.authenticationProvider = authenticationProvider
        self.authenticationContainer = authenticationContainer
        self.contentViewModel = contentViewModel
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
                    self.contentViewModel.state = .signedIn
                }
            })
    }
    
    var signInButtonDisabled: Bool {
        nationName.isEmpty || password.count < 2 // Yes, this is really the only password requirement on NS
    }
}
