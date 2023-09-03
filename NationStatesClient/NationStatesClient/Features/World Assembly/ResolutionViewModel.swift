//
//  ResolutionViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 10/01/2021.
//

import Foundation
import Combine

class ResolutionViewModel: ObservableObject {
    let resolution: Resolution
    @Published var proposedByNation: Nation?
    private let nationDetailsProvider: NationDetailsProvider
    private var cancellable: Cancellable? = nil
    
    init(resolution: Resolution, nationDetailsProvider: NationDetailsProvider) {
        self.resolution = resolution
        self.nationDetailsProvider = nationDetailsProvider
    }
    
    func fetchProposedByNation() async {
        if self.proposedByNation == nil {
            if let nation = try? await nationDetailsProvider.fetchNationDetails(for: resolution.proposedBy) {
                await MainActor.run {
                    self.proposedByNation = nation
                }
            }
        }
    }
}
