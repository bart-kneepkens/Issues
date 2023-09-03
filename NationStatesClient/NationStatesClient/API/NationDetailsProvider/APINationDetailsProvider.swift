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
    
    func fetchCurrentNationDetails() async {
        do {
            let dto = try await NationStatesAPI.fetchNationDetails(authenticationContainer: authenticationContainer, for: authenticationContainer.nationName)
            self.nationDetails.send(Nation(from: dto))
        } catch {
            self.nationDetails.send(nil)
        }
    }
    
    func fetchNationDetails(for nationName: String) async throws -> Nation? {
        let dto = try await NationStatesAPI.fetchNationDetails(authenticationContainer: authenticationContainer, for: nationName)
        return Nation(from: dto)
    }
}
