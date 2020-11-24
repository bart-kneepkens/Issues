//
//  APINationDetailsProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 24/11/2020.
//

import Foundation
import Combine

class APINationDetailsProvider: NationDetailsProvider {
    var nationDetails: Nation?
    private let authenticationContainer: AuthenticationContainer
    private var cancellable: Cancellable?
    
    init(container: AuthenticationContainer) {
        self.authenticationContainer = container
    }
    
    func fetchDetails() {
        self.cancellable = NationStatesAPI
            .fetchNationDetails(authenticationContainer: self.authenticationContainer)
            .map({ Nation(from: $0) })
            .catch({ error -> AnyPublisher<Nation?, Never> in
                return Just(nil).eraseToAnyPublisher()
            })
            .receive(on: DispatchQueue.main)
            .assign(to: \.nationDetails, on: self)
    }
}
