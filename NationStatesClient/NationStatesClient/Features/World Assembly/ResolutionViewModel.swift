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
    
    func fetchProposedByNation() {
        if self.cancellable == nil && self.proposedByNation == nil {
            self.cancellable = nationDetailsProvider
                .fetchNationDetails(for: resolution.proposedBy)
                .catch({ _ in Just(nil).eraseToAnyPublisher() })
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { result in
                    if let nation = result {
                        self.proposedByNation = nation
                    }
                })
        }
    }
}
