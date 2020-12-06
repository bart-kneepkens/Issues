//
//  IssueAnsweredView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 18/10/2020.
//

import SwiftUI

struct RankingView: View {
    let ranking: Ranking
    
    init(_ ranking: Ranking) {
        self.ranking = ranking
    }
    
    private var iconName: String {
        return self.ranking.percentualChange > 0 ? "arrow.up.right" : "arrow.down.right"
    }
    
    private var tintColor: Color {
        return self.ranking.percentualChange > 0 ? .green : .red
    }
    
    var icon: some View {
        Image(systemName: self.iconName)
    }
    
    var body: some View {
        HStack {
            Text("\(self.ranking.scale.name)")
            Spacer()
            icon
            Text("\(String(format: "%.2f", self.ranking.percentualChange))%")
                .foregroundColor(tintColor)
        }
    }
}

struct IssueAnsweredSection: View {
    let result: AnsweredIssueResult
    @State private var showsLegislationSheet = false
    
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
                Section(header: Text("Classification")) {
                    ForEach(result.reclassifications, id: \.self) { classify in
                        Text("\(classify.scale.name): \(classify.from) to \(classify.to)")
                    }
                }
            }
            
            if !result.rankings.isEmpty {
                Section(header: Text("Rankings")) {
                    ForEach(result.rankings.sorted(by: { $0.percentualChange > $1.percentualChange }), id: \.self) { ranking in
                        RankingView(ranking)
                    }
                }
            }
        }
    }
}

#if DEBUG
struct IssueAnsweredSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            IssueAnsweredSection(result: .filler)
        }.listStyle(InsetGroupedListStyle())
    }
}
#endif
