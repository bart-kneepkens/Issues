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
    
    var res: PassthroughSubject<Resolution?, Never> = PassthroughSubject<Resolution?, Never>()
    
    init(authenticationContainer: AuthenticationContainer) {
        self.authenticationContainer = authenticationContainer
    }
    
    private var authenticationContainer: AuthenticationContainer
    private var cancellables: [Cancellable?]? = []
    
    func fetchResolutions() {
        self.fetchResolution(for: .general)
        self.fetchResolution(for: .security)
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
                        case .general: self.generalAssembly.value?.information = response
                        case .security: self.securityCouncil.value?.information = response
                        }
                    }
                })
        )
    }
}
