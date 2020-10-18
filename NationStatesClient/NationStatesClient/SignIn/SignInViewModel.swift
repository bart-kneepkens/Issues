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
    
    var issuesService: IssuesService
    
    init(service: IssuesService) {
        self.issuesService = service
    }
    
    func attemptSignIn() {
        self.signingIn = true
        NationStatesAPI.ping(nationName: nationName, password: password) { result in
            DispatchQueue.main.async {
                self.signingIn = false
                switch result {
                case .success(let authentication):
                    
                    Authentication.shared.nationName = self.nationName
                    Authentication.shared.autoLogin = authentication.autologin
                    Authentication.shared.pin = authentication.pin
                    
                    self.issuesService.fetchIssues()
                    self.shouldNavigateForward = true
                    
                    
                case .failure(let error):
                    self.signInError = error
                }
            }
            
        }
        
    }
}
