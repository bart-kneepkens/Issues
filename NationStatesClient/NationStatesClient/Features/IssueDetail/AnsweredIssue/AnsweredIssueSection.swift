//
//  AnsweredIssueSection.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 18/10/2020.
//

import SwiftUI

struct AnsweredIssueSection: View {
    let result: AnsweredIssueResult
    @State private var showsLegislationSheet = false
    
    private var sortedRankings: [Ranking] {
        // Bigger changes first
        let rankings = result.rankings
            .filter({ abs($0.percentualChange) > 0.005 })
            .sorted(by: { abs($0.percentualChange) > abs($1.percentualChange) })
        
        let positives = rankings.filter({ $0.percentualChange > 0})
        let negatives = rankings.filter({ !positives.contains($0) })
        
        // This is basically a merge of the two arrays, `positives` first and `negatives` second
        return positives + negatives
    }
    
    private var legislationView: some View {
        Section {
            if result.choice.id == Option.dismiss.id {
                Text("Dismissed").foregroundColor(.red)
            } else {
                Button("Legislation Passed") {
                    self.showsLegislationSheet.toggle()
                }
            }
        }
    }
    
    var body: some View {
        Group {
            legislationView.sheet(isPresented: $showsLegislationSheet, content: {
                List {
                    Section(header: Text("Passed Legislation")) {
                        Text(self.result.choice.text)
                    }
                }.listStyle(InsetGroupedListStyle())
            })
            
            if !result.resultText.isEmpty {
                Section(header: Text("Result")) {
                    Text(result.resultText)
                }
            }
            
            if !result.headlines.isEmpty {
                Section(header: Text("Headlines")) {
                    ForEach(result.headlines, id: \.self) { headline in
                        Text(headline)
                    }
                }
            }
            
            if !result.reclassifications.isEmpty {
                Section(header: Text("Classifications")) {
                    ForEach(result.reclassifications, id: \.self) { classify in
                        Text("\(classify.scale.name): \(classify.from) to \(classify.to)")
                    }
                }
            }
            
            if !result.rankings.isEmpty {
                Section(header: Text("Rankings")) {
                    ForEach(sortedRankings, id: \.self) { ranking in
                        RankingView(ranking: ranking)
                    }
                }
            }
        }
    }
}

#if DEBUG
struct AnsweredIssueSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            AnsweredIssueSection(result: .filler)
        }.listStyle(InsetGroupedListStyle())
    }
}
#endif
