//
//  ResolutionLinkViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/02/2025.
//

import Foundation


final class ResolutionLinkViewModel: ObservableObject {
    
    enum State {
        case initial(resulotionId: Int, worldAssembly: WorldAssembly)
        case loaded(Resolution)
    }
    
    @Published
    var state: State
    
    let navigationTitle: String
    
    private let resolutionId: Int
    private let worldAssembly: WorldAssembly
    private let provider: ResolutionProvider
    
    init(resolutionId: Int, worldAssembly: WorldAssembly, resolutionProvider: ResolutionProvider) {
        self.state = .initial(resulotionId: resolutionId, worldAssembly: worldAssembly)
        self.resolutionId = resolutionId
        self.worldAssembly = worldAssembly
        self.provider = resolutionProvider
        self.navigationTitle = "\(worldAssembly.textDescription) #\(resolutionId)"
    }
    
    func fetch() async {
        if let resolution = await provider.fetchPastResolution(id: resolutionId, worldAssembly: worldAssembly) {
            await updateresolution(resolution: resolution)
        }
    }
    
    @MainActor
    private func updateresolution(resolution: Resolution) {
        state = .loaded(resolution)
    }
}
