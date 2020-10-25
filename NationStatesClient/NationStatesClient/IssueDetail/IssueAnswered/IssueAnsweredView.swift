//
//  IssueAnsweredView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 18/10/2020.
//

import SwiftUI

struct IssueAnsweredSection: View {
    let response: AnswerIssueResponse
    
    var body: some View {
        Group {
            Section(header: Text("Legislation passed")) {
                Text(response.result)
            }
            Section(header: Text("Headlines")) {
                ForEach(response.headlines, id: \.self) { headline in
                    Text(headline)
                }
            }
            Section(header: Text("Classification")) {
                ForEach(response.reclassificiations, id: \.self) { classify in
                    Text("\(String(classify.type ?? 0)): \(classify.from ?? "") to \(classify.to ?? "")")
                }
            }
            Section() {
                ForEach(response.rankings, id: \.self) { ranking in
                    Text(String(ranking.percentualChange ?? 0))
                }
            }
        }
    }
}

struct IssueAnsweredSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            IssueAnsweredSection(response: .init(
                                result: "This is the result of your actions",
                                rankings: [.init(id: 2, score: 2, change: 0.5, percentualChange: 0.23)],
                                reclassificiations: [.init(type: 1, from: "Stronk", to: "Much Stronker")],
                                headlines: ["Headline 1", "Headline 2"]))
        }.listStyle(InsetGroupedListStyle())
    }
}
