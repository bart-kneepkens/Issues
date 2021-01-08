//
//  WorldAssemblyView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 30/12/2020.
//

import SwiftUI

struct WorldAssemblyView: View {
    @StateObject var viewModel: WorldAssemblyViewModel
    @State private var selectedVoteOption: VoteOption? = nil
    
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
                ResolutionView(resolution: resolution)
                
                if let localId = resolution.information?.localId, !localId.isEmpty {
                    voteView(resolution, worldAssembly: worldAssembly)
                } else {
                    Section(footer: Text("In order to vote, please apply to join the World Assembly on the NationStates website")) {}
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(worldAssembly.textDescription)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder private func assemblyViewLink(worldAssembly: WorldAssembly) -> some View {
        let resolution = worldAssembly == WorldAssembly.general ? self.viewModel.generalAssemblyResolution : self.viewModel.securityCouncilResolution
        
        NavigationLink(
            destination: assemblyView(worldAssembly: worldAssembly)) {
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
    }
    
    var body: some View {
        List {
            assemblyViewLink(worldAssembly: .general)
            assemblyViewLink(worldAssembly: .security)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("World Assembly")
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
