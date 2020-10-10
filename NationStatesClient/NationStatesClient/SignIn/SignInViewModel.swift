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
    
    var nationNameValidPublisher: AnyPublisher<Bool, Never> {
        $nationName
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    var passwordValidPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    func attemptSignIn() {
        Authorization.shared.nationName = nationName
        Authorization.shared.password = password
        
        IssuesService.shared.fetchIssues()
    }
}
