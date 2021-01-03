//
//  MockedResolutionProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 31/12/2020.
//

import Foundation
import Combine

class MockedResolutionProvider: ResolutionProvider {
    var generalAssembly: Resolution? = .filler
    
    var securityCouncil: Resolution? = .filler
    
    func fetchResolutions() {
        
    }
    
    func vote(for resolution: Resolution, option: VoteOption, localId: String) -> AnyPublisher<VoteOption?, Never> {
        return Just(option)
            .delay(for: 3, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
