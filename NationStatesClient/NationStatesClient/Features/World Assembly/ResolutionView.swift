//
//  ResolutionView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 03/01/2021.
//

import SwiftUI

struct ResolutionView: View {
    @StateObject var viewModel: ResolutionViewModel
    @State private var showingResolutionTextSheet = false
    
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
        if let nation = self.viewModel.proposedByNation {
            // Confusing structure but this is a button with an invisible NavigationLink to show the nation details.
            Button(action: {}, label: {
                Text(nation.name)
            }).background(NavigationLink(destination:
                                            List { NationDetailsView(nation: nation)}.listStyle(InsetGroupedListStyle()),
                                         label: { EmptyView()}).opacity(0))
        } else {
            Text(self.resolution.proposedBy).fontWeight(.medium)
        }
    }
    
    @ViewBuilder private var statisticsView: some View {
        PlainListRow(name: "Category", value: resolution.category)
        PlainListRow(name: "Proposed by", value: AnyView(proposedByView))
            .onAppear {
                self.viewModel.fetchProposedByNation()
            }
        
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
                        Text("Read Resolution")
                    }
                }.sheet(isPresented: $showingResolutionTextSheet, content: {
                    WorldAssemblyResolutionTextSheet(htmlText: htmlText)
                })
            }
        }
    }
}

#if DEBUG
struct ResolutionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ResolutionView(viewModel: ResolutionViewModel(resolution: .filler, nationDetailsProvider: MockedNationDetailsProvider()))
            }.listStyle(InsetGroupedListStyle())
        }
    }
}
#endif
