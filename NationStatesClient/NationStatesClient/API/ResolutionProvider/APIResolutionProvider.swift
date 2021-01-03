//
//  APIResolutionProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 31/12/2020.
//

import Foundation
import Combine

class APIResolutionProvider: ResolutionProvider {
    var generalAssembly: Resolution?
    var securityCouncil: Resolution?
    
    init(authenticationContainer: AuthenticationContainer) {
        self.authenticationContainer = authenticationContainer
    }
    
    private var authenticationContainer: AuthenticationContainer
    private var cancellables: [Cancellable?]? = []
    
    func fetchResolutions() {
        self.fetchResolution(for: .general)
        self.fetchResolution(for: .security)
    }
    
    func vote(for resolution: Resolution, option: VoteOption, localId: String) -> AnyPublisher<VoteOption?, Never> {
        NationStatesAPI.vote(authenticationContainer: self.authenticationContainer, localId: localId, option: option)
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
                    case .general: self.generalAssembly = resolution
                    case .security: self.securityCouncil = resolution
                    }
                    
                    if let resolution = resolution {
                        self.fetchResolutionInformation(for: worldAssembly, from: resolution)
                    }
                })
        )
    }
    
    private func fetchResolutionInformation(for worldAssembly: WorldAssembly, from resolution: Resolution) {
        self.cancellables?.append(
            NationStatesAPI.fetchResolutionInformation(for: worldAssembly, authenticationContainer: self.authenticationContainer)
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { informationResponse in
                    if let response = informationResponse {
                        switch worldAssembly {
                        case .general: self.generalAssembly?.information = response
                        case .security: self.securityCouncil?.information = response
                        }
                    }
                })
        )
    }
}
