//
//  SignInViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import Foundation
import Combine

class SignInViewModel: ObservableObject {
    var nationName: String = "Elest Adra"
    var password: String = "Caac"
    var shouldNavigateForward: Bool = false
    
    @Published var isSigningIn = false
    var signInError: Error?
    
    private var cancellable: Cancellable?
    
    func attemptSignIn() {
        self.isSigningIn = true
        self.cancellable =
            NationStatesAPI.ping(nationName: nationName, password: password)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    self.signInError = err
                default: break
                }
                
                self.isSigningIn = false
            }, receiveValue: { authenticationPair in
                Authentication.shared.nationName = self.nationName
                Authentication.shared.autoLogin = authenticationPair.autologin
                Authentication.shared.pin = authenticationPair.pin
                self.shouldNavigateForward = true
            })
    }
}
