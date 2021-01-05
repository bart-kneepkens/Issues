//
//  ResolutionView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 03/01/2021.
//

import SwiftUI

struct ResolutionView: View {
    
    let resolution: Resolution
    @State private var showingResolutionTextSheet = false
    
    var timeLeftToVote: String? {
        if let time = resolution.timeLeftToVote {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.day, .hour, .minute]
            formatter.unitsStyle = .full
            formatter.maximumUnitCount = 1
            
            return formatter.string(from: time)
        }
        return nil
    }
    
    @ViewBuilder private var statisticsView: some View {
        PlainListRow(name: "Category", value: resolution.category)
        PlainListRow(name: "Proposed by", value: resolution.proposedBy)
        
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
                    .frame(height: 72)) {
            
        }
        
        Section {
            Button(action: {
                self.showingResolutionTextSheet.toggle()
            }) {
                HStack {
                    Image(systemName: "book")
                    Text("Read Description")
                }
            }.sheet(isPresented: $showingResolutionTextSheet, content: {
                if let information = resolution.information, let htmlText = information.textHTML {
                    WorldAssemblyResolutionTextSheet(htmlText: htmlText)
                }
            })
        }
    }
}

struct ResolutionView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ResolutionView(resolution: .filler)
        }.listStyle(InsetGroupedListStyle())
    }
}
