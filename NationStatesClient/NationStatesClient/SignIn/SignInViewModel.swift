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
    
    func attemptSignIn() {
        NationStatesAPI.ping(nationName: nationName, password: password) { result in
            switch result {
            case .success(let authentication):
                
                Authentication.shared.autoLogin = authentication.autologin
                Authentication.shared.pin = authentication.pin
                
                DispatchQueue.main.async {
                    self.shouldNavigateForward = true
                }
                
                
            case .failure(let error): break
            }
        }
    
    }
}
