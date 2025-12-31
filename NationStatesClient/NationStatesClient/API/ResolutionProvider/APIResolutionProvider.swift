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
        return Resolution(from: dto)
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
                })
        )
    }
}
