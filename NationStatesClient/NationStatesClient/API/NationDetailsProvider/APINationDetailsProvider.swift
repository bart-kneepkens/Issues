//
//  APINationDetailsProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 24/11/2020.
//

import Foundation
import Combine

class APINationDetailsProvider: NationDetailsProvider {
    let authenticationContainer: AuthenticationContainer
    
    init(container: AuthenticationContainer) {
        self.authenticationContainer = container
    }
    
    func fetchDetails() -> AnyPublisher<Nation?, APIError> {
        return NationStatesAPI
            .fetchNationDetails(authenticationContainer: self.authenticationContainer)
            .map({ Nation(from: $0) })
            .eraseToAnyPublisher()
    }
}
