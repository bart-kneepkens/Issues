//
//  ResolutionView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 03/01/2021.
//

import SwiftUI

struct ResolutionView: View {
    @Environment(\.viewModelFactory) var viewModelFactory: ViewModelFactory
    @StateObject var viewModel: ResolutionViewModel
    @State private var showingResolutionTextSheet = false
    
    @State private var selectedLinkType: WorldAssemblyResolutionTextSheet.LinkType?
    
    @Binding var navigationPath: NavigationPath
    
    private var resolution: Resolution {
        self.viewModel.resolution
    }
    
    private var timeLeftToVote: String? {
        if let time = resolution.timeLeftToVote {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.day, .hour, .minute]
            formatter.unitsStyle = .full
            formatter.maximumUnitCount = 1
            
            return formatter.string(from: time)
        }
        return nil
    }
    
    @ViewBuilder private var proposedByView: some View {
        NationLinkView(
            viewModel: viewModelFactory.nationLinkViewModel(self.resolution.proposedBy)
        )
    }
    
    @ViewBuilder private var statisticsView: some View {
        PlainListRow(name: "Category", value: resolution.category)
        PlainListRow(name: "Proposed by", value: AnyView(proposedByView))
        
        if let timeLeft = self.timeLeftToVote {
            PlainListRow(name: "Voting ends in", value: timeLeft)
        }
    }

    var body: some View {
        Section {
            Text(resolution.name).font(.title).bold().padding(.vertical)
            statisticsView
        }
        
        Section(header: VotesDistributionChart(votesFor: resolution.totalVotesFor, votesAgainst: resolution.totalVotesAgainst)
                    .frame(height: 72)) {}
        
        Section {
            if let information = resolution.information, let htmlText = information.textHTML {
                Button(action: {
                    self.showingResolutionTextSheet.toggle()
                }) {
                    HStack {
                        Image(systemName: "book")
                        Text("Read Resolution").fontWeight(.medium)
                    }
                }
                .sheet(
                    isPresented: $showingResolutionTextSheet,
                    onDismiss: {
                        if let preparedLinkType = viewModel.preparedLinkType {
                            navigationPath.append(WorldAssemblyNavigationDestination.link(preparedLinkType))
                        }
                    },
                    content: {
                        WorldAssemblyResolutionTextSheet(htmlText: htmlText)
                            .onLinkTap { link in
                                viewModel.preparedLinkType = link
                                self.showingResolutionTextSheet = false
                            }
                    }
                )
            }
        }
    }
}

#if DEBUG
struct ResolutionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ResolutionView(viewModel: ResolutionViewModel(resolution: .filler, nationDetailsProvider: MockedNationDetailsProvider()), navigationPath: .constant(.init()))
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
}
#endif
