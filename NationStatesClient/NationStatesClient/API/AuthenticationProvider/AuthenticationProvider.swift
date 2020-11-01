//
//  AuthenticationProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 29/10/2020.
//

import Combine

protocol AuthenticationProvider {
    func authenticate(nationName: String, password: String) -> AnyPublisher<AuthenticationPair, APIError>
    func authenticate() -> AnyPublisher<Bool, APIError>
}
