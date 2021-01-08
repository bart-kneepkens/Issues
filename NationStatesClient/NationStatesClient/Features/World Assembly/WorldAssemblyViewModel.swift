//
//  WorldAssemblyViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 30/12/2020.
//

import Foundation
import Combine

class WorldAssemblyViewModel: ObservableObject {
    @Published var generalAssemblyResolution: Resolution?
    @Published var securityCouncilResolution: Resolution?
    
    @Published var isVoting: Bool = false
    
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
        
        self.castedGeneralAssemblyVote = nationDetailsProvider.nationDetails.value?.generalAssemblyVote
        self.castedSecurityCouncilVote = nationDetailsProvider.nationDetails.value?.securityCouncilVote

        self.cancellables?.append(resolutionProvider.generalAssembly.assign(to: \.generalAssemblyResolution, on: self))
        self.cancellables?.append(resolutionProvider.securityCouncil.assign(to: \.securityCouncilResolution, on: self))
    }
    
    func vote(on resolution: Resolution, option: VoteOption, worldAssembly: WorldAssembly, localId: String) {
        self.isVoting = true
        self.cancellables?.append(
            self.resolutionProvider
                .vote(for: resolution, worldAssembly: worldAssembly, option: option, localId: localId)
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { receivedOption in
                    switch worldAssembly {
                    case .general: self.castedGeneralAssemblyVote = receivedOption
                    case .security: self.castedSecurityCouncilVote = receivedOption
                    }
                })
        )
    }
}
