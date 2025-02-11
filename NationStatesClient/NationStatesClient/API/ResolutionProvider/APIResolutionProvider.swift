//
//  APIResolutionProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 31/12/2020.
//

import Foundation
import Combine

class APIResolutionProvider: ResolutionProvider {
    
    let generalAssembly = CurrentValueSubject<Resolution?, Never>(nil)
    let securityCouncil = CurrentValueSubject<Resolution?, Never>(nil)
    
    init(authenticationContainer: AuthenticationContainer) {
        self.authenticationContainer = authenticationContainer
    }
    
    private var authenticationContainer: AuthenticationContainer
    private var cancellables: [Cancellable?]? = []
    
    func fetchResolutions() {
        self.fetchResolution(for: .general)
        self.fetchResolution(for: .security)
    }
    
    func fetchPastResolution(id: Int, worldAssembly: WorldAssembly) async -> Resolution? {
        guard let dto = try? await NationStatesAPI
            .fetchResolutionById(
                authenticationContainer: authenticationContainer,
                id: id,
                worldAssembly: worldAssembly
            ) else { return nil }
        guard var resolution = Resolution(from: dto) else { return nil }
        
        resolution.information = try? await NationStatesAPI.fetchPastResolutionInformation(id: id, worldAssembly: worldAssembly, authenticationContainer: authenticationContainer)
        
        return resolution
    }
    
    func vote(for resolution: Resolution, worldAssembly: WorldAssembly, option: VoteOption, localId: String) -> AnyPublisher<VoteOption?, Never> {
        NationStatesAPI.vote(authenticationContainer: self.authenticationContainer, worldAssembly: worldAssembly, localId: localId, option: option)
    }
    
    private func fetchResolution(for worldAssembly: WorldAssembly) {
        self.cancellables?.append(
            NationStatesAPI
                .fetchResolution(authenticationContainer: self.authenticationContainer, worldAssembly: worldAssembly)
                .map({ Resolution(from: $0) })
                .catch({ error -> AnyPublisher<Resolution?, Never> in
                    return Just(nil).eraseToAnyPublisher()
                })
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { resolution in
                    switch worldAssembly {
                    case .general: self.generalAssembly.send(resolution)
                    case .security: self.securityCouncil.send(resolution)
                    }
                    
                    if let resolution = resolution {
                        // Fetch information, which include HTML text and localId
                        self.fetchResolutionInformation(for: worldAssembly)
                    }
                })
        )
    }
    
    private func fetchResolutionInformation(for worldAssembly: WorldAssembly) {
        self.cancellables?.append(
            NationStatesAPI.fetchResolutionInformation(for: worldAssembly, authenticationContainer: self.authenticationContainer)
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { informationResponse in
                    if let response = informationResponse {
                        switch worldAssembly {
                        case .general: self.generalAssembly.value?.information = response
                        case .security: self.securityCouncil.value?.information = response
                        }
                    }
                })
        )
    }
}
