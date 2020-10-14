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
    
    var issuesService: IssuesService
    
    init(service: IssuesService) {
        self.issuesService = service
    }
    
    func attemptSignIn() {
        NationStatesAPI.ping(nationName: nationName, password: password) { result in
            switch result {
            case .success(let authentication):
                
                Authentication.shared.nationName = self.nationName
                Authentication.shared.autoLogin = authentication.autologin
                Authentication.shared.pin = authentication.pin
                
                self.issuesService.fetchIssues()
                
                DispatchQueue.main.async {
                    self.shouldNavigateForward = true
                }
                
                
            case .failure(_): break
            }
        }
    
    }
}
