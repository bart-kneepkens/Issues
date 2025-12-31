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

    private let resolutionProvider: ResolutionProvider
    private let authenticationContainer: AuthenticationContainer
    private var cancellables: [Cancellable?]? = []
    
    init(
        authenticationContainer: AuthenticationContainer,
        resolutionProvider: ResolutionProvider,
        nationDetailsProvider: NationDetailsProvider
    ) {
        self.authenticationContainer = authenticationContainer
        self.resolutionProvider = resolutionProvider
        
        self.castedGeneralAssemblyVote = nationDetailsProvider.nationDetails.value?.generalAssemblyVote
        self.castedSecurityCouncilVote = nationDetailsProvider.nationDetails.value?.securityCouncilVote

        // TODO: Weak references here
        self.cancellables?.append(resolutionProvider.generalAssembly.assign(to: \.generalAssemblyResolution, on: self))
        self.cancellables?.append(resolutionProvider.securityCouncil.assign(to: \.securityCouncilResolution, on: self))
    }
}
