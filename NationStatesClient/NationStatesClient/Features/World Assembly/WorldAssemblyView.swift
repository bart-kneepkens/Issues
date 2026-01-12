//
//  WorldAssemblyView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 30/12/2020.
//

import SwiftUI

enum WorldAssemblyNavigationDestination: Hashable {
    case link(WorldAssemblyResolutionTextSheet.LinkType)
    case worldAssembly(WorldAssembly)
}

struct WorldAssemblyView: View {
    @Environment(\.viewModelFactory) var viewModelFactory: ViewModelFactory
    @StateObject var viewModel: WorldAssemblyViewModel
    @State private var selectedVoteOption: VoteOption? = nil
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navigation: Navigation
    
    var body: some View {
            List {
                assemblyViewLink(worldAssembly: .general)
                assemblyViewLink(worldAssembly: .security)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("World Assembly")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
    }
    
    @ViewBuilder private func assemblyView(worldAssembly: WorldAssembly) -> some View {
        let resolution = worldAssembly == WorldAssembly.general ? self.viewModel.generalAssemblyResolution : self.viewModel.securityCouncilResolution
        
        List {
            if let resolution = resolution {
                ResolutionView(viewModel: viewModelFactory.resolutionViewModel(resolution))
            }
        }
        .navigationTitle(worldAssembly.textDescription)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder private func assemblyViewLink(worldAssembly: WorldAssembly) -> some View {
        let resolution = worldAssembly == WorldAssembly.general ? self.viewModel.generalAssemblyResolution : self.viewModel.securityCouncilResolution
        
        Button {
            if let resolution {
                navigation.push(.worldAssembly(worldAssembly, resolution))
            }
        } label: {
            HStack {
                Image(systemName: worldAssembly.iconName)
                VStack {
                    HStack {
                        Text(worldAssembly.textDescription).font(.headline)
                        Spacer()
                    }
                    HStack {
                        Text(resolution?.name ?? "No resolution at vote").font(.subheadline)
                        Spacer()
                    }
                }
            }.frame(height: 64)
        }
        .disabled(resolution == nil)
        .tint(.primary)
    }
}

#if DEBUG
struct WorldAssemblyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WorldAssemblyView(viewModel: .init(authenticationContainer: .init(), resolutionProvider: MockedResolutionProvider(), nationDetailsProvider: MockedNationDetailsProvider()))
        }
    }
}
#endif
