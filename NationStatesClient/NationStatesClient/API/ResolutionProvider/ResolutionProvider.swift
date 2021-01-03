//
//  ResolutionProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 31/12/2020.
//

import Foundation
import Combine

protocol ResolutionProvider {
    var generalAssembly: Resolution? { get }
    var securityCouncil: Resolution? { get }
    
    func fetchResolutions()
    func vote(for resolution: Resolution, option: VoteOption, localId: String) -> AnyPublisher<VoteOption?, Never>
}

