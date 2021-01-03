//
//  WorldAssemblyViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 30/12/2020.
//

import Foundation
import Combine

class WorldAssemblyViewModel: ObservableObject {
    var generalAssemblyResolution: Resolution? {
        resolutionProvider.generalAssembly
    }
    
    var securityCouncilResolution: Resolution? {
        resolutionProvider.securityCouncil
    }
    
    @Published var isVoting: Bool = false
    @Published var localId: String?
    @Published var castedGeneralAssemblyVote: VoteOption? {
        didSet {
            isVoting = false
        }
    }
    
    @Published var castedSecurityCouncilVote: VoteOption? {
        didSet {
            isVoting = false
        }
    }

    private var resolutionProvider: ResolutionProvider
    private var authenticationContainer: AuthenticationContainer
    private var cancellables: [Cancellable?]? = []
    
    init(authenticationContainer: AuthenticationContainer, resolutionProvider: ResolutionProvider, nationDetailsProvider: NationDetailsProvider) {
        self.authenticationContainer = authenticationContainer
        self.resolutionProvider = resolutionProvider
        
        self.castedGeneralAssemblyVote = nationDetailsProvider.nationDetails?.generalAssemblyVote
        self.castedSecurityCouncilVote = nationDetailsProvider.nationDetails?.securityCouncilVote
    }
    
    func vote(on resolution: Resolution, option: VoteOption, worldAssembly: WorldAssembly, localId: String) {
        self.isVoting = true
        self.cancellables?.append(
            self.resolutionProvider
                .vote(for: resolution, option: option, localId: localId)
                .sink(receiveValue: { receivedOption in
                    switch worldAssembly {
                    case .general: self.castedGeneralAssemblyVote = receivedOption
                    case .security: self.castedSecurityCouncilVote = receivedOption
                    }
                    
                })
        )
    }
}
