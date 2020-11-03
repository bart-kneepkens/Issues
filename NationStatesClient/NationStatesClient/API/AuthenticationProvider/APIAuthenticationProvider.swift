//
//  APIAuthenticationProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 29/10/2020.
//

import Foundation
import Combine

class APIAuthenticationProvider: AuthenticationProvider {
    private let authenticationContainer: AuthenticationContainer
    
    init(authenticationContainer: AuthenticationContainer) {
        self.authenticationContainer = authenticationContainer
    }

    func authenticate(authenticationContainer: AuthenticationContainer) -> AnyPublisher<Bool, APIError> {
        return NationStatesAPI.ping(authenticationContainer: self.authenticationContainer)
    }
}
