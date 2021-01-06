//
//  ResolutionProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 31/12/2020.
//

import Foundation
import Combine

protocol ResolutionProvider {
    var generalAssembly: CurrentValueSubject<Resolution?, Never> { get }
    var securityCouncil: CurrentValueSubject<Resolution?, Never> { get }
    
    func fetchResolutions()
    func vote(for resolution: Resolution, worldAssembly: WorldAssembly, option: VoteOption, localId: String) -> AnyPublisher<VoteOption?, Never>
}

