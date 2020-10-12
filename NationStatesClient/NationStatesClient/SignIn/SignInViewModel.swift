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
        Authorization.shared.nationName = nationName
        Authorization.shared.password = password
        
        NationStatesAPI.ping { result in
            switch result {
            case .success(()): self.shouldNavigateForward = true
            case .failure(let error): break
            }
        }
    }
}
