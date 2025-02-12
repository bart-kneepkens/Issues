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
    
    var preparedLinkType: WorldAssemblyResolutionTextSheet.LinkType?
    
    private let nationDetailsProvider: NationDetailsProvider
    private var cancellable: Cancellable? = nil
    
    init(resolution: Resolution, nationDetailsProvider: NationDetailsProvider) {
        self.resolution = resolution
        self.nationDetailsProvider = nationDetailsProvider
    }

}
