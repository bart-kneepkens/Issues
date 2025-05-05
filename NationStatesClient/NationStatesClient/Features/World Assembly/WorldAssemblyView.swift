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
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                assemblyViewLink(worldAssembly: .general)
                assemblyViewLink(worldAssembly: .security)
                worldAssemblyStatusSectionView
            }
            .listStyle(.insetGrouped)
            .navigationTitle("World Assembly")
            .navigationDestination(for: WorldAssemblyNavigationDestination.self) { destination in
                switch destination {
                case let .link(linkType):
                    switch linkType {
                    case let .nation(name: nationName):
                        FetchedNationView(viewModel: viewModelFactory.fetchedNationViewModel(nationName))
                    case let .region(name: regionName):
                        RegionView(viewModel: viewModelFactory.regionViewModel(regionName))
                    case let .otherResolution(id: resolutionId, worldAssembly: wass):
                        ResolutionLinkView(viewModel: viewModelFactory.resolutionLinkViewModel(id: resolutionId, worldAssembly: wass), navigationPath: $navigationPath)
                    }
                case let .worldAssembly(worldAssembly):
                    self.assemblyView(worldAssembly: worldAssembly)
                }
                
            }
        }
    }
    
    private var worldAssemblyStatusSectionView: some View {
        Section("⚠ For your information") {
            Text("The NationStates API currently doesn't support voting in the World Assembly, and recent bot protection rules have made it impossible to do so using other means. For now, World Assembly is read-only in Issues. More information can be found on the forum.")
                .font(.subheadline)
        }
    }
    
    @ViewBuilder private func placeVoteView(resolution: Resolution, worldAssembly: WorldAssembly) -> some View {
        HStack {
            Button("Vote For") {
                self.selectedVoteOption = .voteFor
            }
            .foregroundColor(VoteOption.voteFor.color)
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
            
            Button("Vote Against") {
                self.selectedVoteOption = .voteAgainst
            }
            .foregroundColor(VoteOption.voteAgainst.color)
            .buttonStyle(BorderlessButtonStyle())
        }
        .alert(item: $selectedVoteOption) { option -> Alert in
            Alert(title: Text("Are you sure you want to vote \"\(option.shortDescription)\" on resolution \"\(resolution.name)\"?"),
                  primaryButton: .cancel(),
                  secondaryButton: .default(Text("Yes"), action: {
                    if let localId = resolution.information?.localId {
                        viewModel.vote(on: resolution, option: option, worldAssembly: worldAssembly, localId: localId)
                    }
                  }))
        }
    }
    
    @ViewBuilder private func voteView(_ resolution: Resolution, worldAssembly: WorldAssembly) -> some View {
        let castedVote = worldAssembly == WorldAssembly.general ? self.viewModel.castedGeneralAssemblyVote : self.viewModel.castedSecurityCouncilVote
        
        Section {
            if let castedVote = castedVote {
                HStack {
                    Text("Your vote:")
                    Spacer()
                    Text(castedVote.shortDescription)
                        .fontWeight(.medium)
                        .foregroundColor(castedVote.color)
                }
            } else if self.viewModel.isVoting  {
                ProgressView()
            } else {
                placeVoteView(resolution: resolution, worldAssembly: worldAssembly)
            }
        }
    }
    
    @ViewBuilder private func assemblyView(worldAssembly: WorldAssembly) -> some View {
        let resolution = worldAssembly == WorldAssembly.general ? self.viewModel.generalAssemblyResolution : self.viewModel.securityCouncilResolution
        
        List {
            if let resolution = resolution {
                ResolutionView(viewModel: viewModelFactory.resolutionViewModel(resolution), navigationPath: $navigationPath)
                
                if let localId = resolution.information?.localId, !localId.isEmpty {
                    voteView(resolution, worldAssembly: worldAssembly)
                } else {
                    Section(footer: Text("In order to vote, please apply to join the World Assembly on the NationStates website")) {}
                }
            }
        }
        .navigationTitle(worldAssembly.textDescription)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder private func assemblyViewLink(worldAssembly: WorldAssembly) -> some View {
        let resolution = worldAssembly == WorldAssembly.general ? self.viewModel.generalAssemblyResolution : self.viewModel.securityCouncilResolution
        
        Button {
            navigationPath.append(WorldAssemblyNavigationDestination.worldAssembly(worldAssembly))
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
