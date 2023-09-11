//
//  MockedAuthenticationProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 30/10/2020.
//

import Foundation
import Combine

#if DEBUG
class MockedAuthenticationProvider: AuthenticationProvider {
    private let success: Bool
    private let delay: Int
    
    init(success: Bool, delay: Int = 2){
        self.success = success
        self.delay = delay
    }
    
    func authenticate(authenticationContainer: AuthenticationContainer) -> AnyPublisher<Bool, APIError> {
        Just(self.success)
            .delay(for: .seconds(self.delay), scheduler: DispatchQueue.main)
            .mapError({ _ in APIError.conflict })
            .eraseToAnyPublisher()
    }
}
#endif
