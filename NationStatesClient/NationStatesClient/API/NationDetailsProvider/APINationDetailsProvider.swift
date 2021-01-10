//
//  APINationDetailsProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 24/11/2020.
//

import Foundation
import Combine

class APINationDetailsProvider: NationDetailsProvider {
    var nationDetails = CurrentValueSubject<Nation?, Never>(nil)
    
    private let authenticationContainer: AuthenticationContainer
    private var cancellable: Cancellable?
    
    init(container: AuthenticationContainer) {
        self.authenticationContainer = container
    }
    
    func fetchCurrentNationDetails() {
        self.cancellable = NationStatesAPI
            .fetchNationDetails(authenticationContainer: self.authenticationContainer, for: self.authenticationContainer.nationName)
            .map({ Nation(from: $0) })
            .catch({ error -> AnyPublisher<Nation?, Never> in
                return Just(nil).eraseToAnyPublisher()
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { details in
                self.nationDetails.send(details)
                if let details = details {
                    self.authenticationContainer.nationName = details.name
                }
            })
    }
    
    func fetchNationDetails(for nationName: String) -> AnyPublisher<Nation?, APIError> {
        NationStatesAPI
            .fetchNationDetails(authenticationContainer: self.authenticationContainer, for: nationName)
            .map({ Nation(from: $0) })
            .eraseToAnyPublisher()
    }
}
