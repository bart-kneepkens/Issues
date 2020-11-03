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
    private let pair: AuthenticationPair
    private let success: Bool
    
    init(pair: AuthenticationPair = (autologin: "mocked-autologin", pin: "mocked-pin"),
         success: Bool = true) {
        self.pair = pair
        self.success = success
    }
    
    func authenticate(authenticationContainer: AuthenticationContainer) -> AnyPublisher<Bool, APIError> {
        return Just(self.success)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .mapError({ _ in APIError.conflict })
            .eraseToAnyPublisher()
    }
}
#endif
