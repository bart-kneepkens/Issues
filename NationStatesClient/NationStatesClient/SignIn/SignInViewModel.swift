//
//  SignInViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import Foundation
import Combine

class SignInViewModel: ObservableObject {
    @Published var nationName: String = ""
    @Published var password: String = ""
    
    func attemptSignIn() {
        Authorization.shared.nationName = nationName
        Authorization.shared.password = password
        
        IssuesService.shared.fetchIssues()
    }
}
