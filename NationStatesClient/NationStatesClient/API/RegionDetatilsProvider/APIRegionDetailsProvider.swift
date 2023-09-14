//
//  APIRegionDetailsProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 13/09/2023.
//

import Foundation

final class APIRegionDetailsProvider: RegionDetailsProvider {
    
    private let authenticationContainer: AuthenticationContainer
    
    init(container: AuthenticationContainer) {
        self.authenticationContainer = container
    }
    
    func fetchRegionDetails(with regionName: String) async -> Region? {
        do {
            let dto = try await NationStatesAPI.fetchRegionDetails(authenticationContainer: authenticationContainer, for: regionName)
            return Region(from: dto)
        } catch {
            return nil
        }
    }
}
