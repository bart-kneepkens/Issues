//
//  NationViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 01/11/2020.
//

import Foundation

class NationViewModel: ObservableObject {
    private let authenticationContainer: AuthenticationContainer
    
    init(authenticationContainer: AuthenticationContainer) {
        self.authenticationContainer = authenticationContainer
    }
    
    func signOut() {
        self.authenticationContainer.signOut()
    }
}
