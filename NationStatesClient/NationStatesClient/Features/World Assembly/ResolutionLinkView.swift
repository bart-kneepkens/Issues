//
//  ResolutionLinkView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/02/2025.
//

import SwiftUI

struct ResolutionLinkView: View {
    @Environment(\.viewModelFactory) var viewModelFactory: ViewModelFactory
    
    @StateObject var viewModel: ResolutionLinkViewModel
    
    
    var body: some View {
        switch viewModel.state {
        case .initial:
            ProgressView()
                .task {
                    await viewModel.fetch()
                }
        case .loaded(let resolution):
            List {
                ResolutionView(viewModel: viewModelFactory.resolutionViewModel(resolution))
            }
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
