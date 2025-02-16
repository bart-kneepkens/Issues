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
    
    @Published var worldAssemblyStatusText: String?

    private let resolutionProvider: ResolutionProvider
    private let authenticationContainer: AuthenticationContainer
    private let worldAssemblyStatusProvider: WorldAssemblyStatusProvider
    private var cancellables: [Cancellable?]? = []
    
    init(
        authenticationContainer: AuthenticationContainer,
        resolutionProvider: ResolutionProvider,
        nationDetailsProvider: NationDetailsProvider,
        worldAssemblyStatusProvider: WorldAssemblyStatusProvider
    ) {
        self.authenticationContainer = authenticationContainer
        self.resolutionProvider = resolutionProvider
        self.worldAssemblyStatusProvider = worldAssemblyStatusProvider
        
        self.castedGeneralAssemblyVote = nationDetailsProvider.nationDetails.value?.generalAssemblyVote
        self.castedSecurityCouncilVote = nationDetailsProvider.nationDetails.value?.securityCouncilVote

        // TODO: Weak references here
        self.cancellables?.append(resolutionProvider.generalAssembly.assign(to: \.generalAssemblyResolution, on: self))
        self.cancellables?.append(resolutionProvider.securityCouncil.assign(to: \.securityCouncilResolution, on: self))
        
        Task {
            if let status = await worldAssemblyStatusProvider.status {
                await MainActor.run {
                    self.worldAssemblyStatusText = status
                }
            }
        }
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
