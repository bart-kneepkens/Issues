//
//  AuthenticationProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 29/10/2020.
//

import Combine

protocol AuthenticationProvider {
    func authenticate(authenticationContainer: AuthenticationContainer) -> AnyPublisher<Bool, APIError>
}
