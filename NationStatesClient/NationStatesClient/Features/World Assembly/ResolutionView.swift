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
    
    @ViewBuilder private var statisticsView: some View {
        HStack {
            Text("Category:")
            Spacer()
            Text(resolution.category).fontWeight(.medium)
        }
        if resolution.option != "0" {
            HStack {
                Text("Area of Effect:")
                Spacer()
                Text(resolution.option).fontWeight(.medium)
            }
        }
        HStack {
            Text("Proposed by:")
            Spacer()
            Text(resolution.proposedBy).fontWeight(.medium)
        }
    }
    
    var body: some View {
        Section {
            Text(resolution.name)
                .font(.system(size: 24, weight: .bold))
        }
        
        Section(header: VotesDistributionChart(votesFor: resolution.totalVotesFor, votesAgainst: resolution.totalVotesAgainst)
                    .frame(height: 72)) {
            statisticsView
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
