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
    @State private var selectedNationName: String? = nil
    
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
    
    private var shouldNavigateToSelectedNation: Binding<Bool> {
        .init(get: { self.selectedNationName != nil }, set: { _ in
            // Dismissed
            self.selectedNationName = nil
        })
    }
    
    @ViewBuilder private var proposedByView: some View {
         if let nation = self.viewModel.proposedByNation {
            // Confusing structure but this is a button with an invisible NavigationLink to show the nation details.
            Text(nation.name)
                .fontWeight(.medium)
                .foregroundColor(.accentColor)
                .background(proposedByNationLink)
        } else {
            Text(self.resolution.proposedBy).fontWeight(.medium)
        }
    }
    
    @ViewBuilder private var statisticsView: some View {
        PlainListRow(name: "Category", value: resolution.category)
        PlainListRow(name: "Proposed by", value: AnyView(proposedByView))
            .onAppear {
                Task {
                    await self.viewModel.fetchProposedByNation()
                }
            }
        
        if let timeLeft = self.timeLeftToVote {
            PlainListRow(name: "Voting ends in", value: timeLeft)
        }
    }
    
    @ViewBuilder private var selectedNationDestination: some View {
        if let selectedNationName = self.selectedNationName {
            FetchedNationView(viewModel: viewModelFactory.fetchedNationViewModel(selectedNationName))
        }
    }
    
    @ViewBuilder private var proposedByNationDestination: some View {
        if let nation = self.viewModel.proposedByNation {
            List {
                NationDetailsView(nation: nation)
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
    
    private var selectedNationLink: some View {
        NavigationLink(destination: selectedNationDestination, isActive: shouldNavigateToSelectedNation) {
            EmptyView()
        }
        .opacity(0.0)
    }
    
    private var proposedByNationLink: some View {
        NavigationLink(destination: proposedByNationDestination) {
            EmptyView()
        }.opacity(0.0)
    }
    
    
    var body: some View {
        Section {
            Text(resolution.name).font(.title).bold().padding(.vertical)
            statisticsView
        }
        
        Section(header: VotesDistributionChart(votesFor: resolution.totalVotesFor, votesAgainst: resolution.totalVotesAgainst)
                    .frame(height: 72)) {}.background(selectedNationLink)
        
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
                .sheet(isPresented: $showingResolutionTextSheet, content: {
                    WorldAssemblyResolutionTextSheet(htmlText: htmlText)
                        .onNationTap { nationName in
                            self.showingResolutionTextSheet = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.selectedNationName = nationName
                            }
                        }
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
