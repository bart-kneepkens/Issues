//
//  SignInViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import Foundation
import Combine

class SignInViewModel: ObservableObject {
    @Published var nationName: String = "Elest Adra"
    @Published var password: String = "Cacvu3-cekxed-coxpac"
    @Published var shouldNavigateForward: Bool = false
    
    @Published var signingIn = false
    @Published var signInError: Error?
    
    private var cancellable: Cancellable?
    
    func attemptSignIn() {
        self.signingIn = true
        self.cancellable = NationStatesAPI.ping(nationName: nationName, password: password).sink(receiveCompletion: { _ in }, receiveValue: { (pair) in
            Authentication.shared.nationName = self.nationName
            Authentication.shared.autoLogin = pair.autologin
            Authentication.shared.pin = pair.pin
            
//            self.issuesService.fetchIssues()
            self.shouldNavigateForward = true
        })
        
    }
}
