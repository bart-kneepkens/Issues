//
//  APIAuthenticationProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 29/10/2020.
//

import Foundation
import Combine

class APIAuthenticationProvider: AuthenticationProvider {
    private let authentication = Authentication.shared
    
    func authenticate(nationName: String, password: String) -> AnyPublisher<AuthenticationPair, APIError> {
        return NationStatesAPI.ping(nationName: nationName, password: password)
    }
    
    func authenticate() -> AnyPublisher<Bool, APIError> {
        guard let nationName = authentication.nationName else {
            return Fail(error: APIError.unauthorized).eraseToAnyPublisher()
        }
        return NationStatesAPI.ping(nationName: nationName)
    }
}
