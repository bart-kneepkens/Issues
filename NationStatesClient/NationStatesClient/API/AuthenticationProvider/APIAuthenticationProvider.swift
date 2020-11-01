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
    
    func authenticate(nationName: String, password: String) -> AnyPublisher<AuthenticationPair, APIError> {
        return NationStatesAPI.ping(nationName: nationName, password: password)
    }
    
    func authenticate() -> AnyPublisher<Bool, APIError> {
        guard let pair = authenticationContainer.pair else {
            return Fail(error: APIError.unauthorized).eraseToAnyPublisher()
        }
        
        return NationStatesAPI.ping(authentication: pair)
    }
}
