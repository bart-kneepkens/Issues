//
//  MockedResolutionProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 31/12/2020.
//

import Foundation
import Combine

#if DEBUG
class MockedResolutionProvider: ResolutionProvider {
    var generalAssembly: CurrentValueSubject<Resolution?, Never>
    var securityCouncil: CurrentValueSubject<Resolution?, Never>
    let delay: Int
    
    init(generalAssemblyResolution: Resolution = .filler, securityCouncilResolution: Resolution = .filler, delay: Int = 2) {
        self.generalAssembly = CurrentValueSubject<Resolution?, Never>(generalAssemblyResolution)
        self.securityCouncil = CurrentValueSubject<Resolution?, Never>(securityCouncilResolution)
        self.delay = delay
    }
    
    func fetchResolutions() {}
    
    func vote(for resolution: Resolution, worldAssembly: WorldAssembly, option: VoteOption, localId: String) -> AnyPublisher<VoteOption?, Never> {
        return Just(option)
            .delay(for: .seconds(self.delay), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchPastResolution(id: Int, worldAssembly: WorldAssembly) async -> Resolution? {
        nil
    }
}
#endif
