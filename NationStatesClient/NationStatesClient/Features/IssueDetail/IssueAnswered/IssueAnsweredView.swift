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
    
    var body: some View {
        Group {
            Section(header: Text("Legislation passed")) {
                Text(result.resultText)
            }
            
            Section(header: Text("Headlines")) {
                ForEach(result.headlines, id: \.self) { headline in
                    Text(headline)
                }
            }
            
            if !result.reclassifications.isEmpty {
                Section(header: Text("Classification")) {
                    ForEach(result.reclassifications, id: \.self) { classify in
                        Text("\(classify.scale.name): \(classify.from) to \(classify.to)")
                    }
                }
            }
            
            Section(header: Text("Rankings")) {
                ForEach(result.rankings.sorted(by: { $0.percentualChange > $1.percentualChange }), id: \.self) { ranking in
                    RankingView(ranking)
                }
            }
        }
    }
}

struct IssueAnsweredSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            IssueAnsweredSection(result: .init(dto: .init(
                resultText: "This is the result of your actions",
                headlines: ["Headline 1", "Headline 2"],
                reclassifications: [.init(type: 1, from: "Stronk", to: "Much Stronker")],
                rankings: [
                    .init(id: 2, score: 2, change: 0.5, percentualChange: 0.23),
                    .init(id: 2, score: 2, change: 0.5, percentualChange: 1.33)
                ]
            )))
        }.listStyle(InsetGroupedListStyle())
    }
}
