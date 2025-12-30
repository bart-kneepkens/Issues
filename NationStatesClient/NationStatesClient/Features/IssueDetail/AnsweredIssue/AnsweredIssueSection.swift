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
    
    @ViewBuilder
    private var titleView: some View {
        HStack {
            Text(result.isDismissed ? "Issue Dismissed" : "Legislation Passed")
                .font(.system(size: 24, weight: .bold))
            Spacer()
            Button(action: {
                showsLegislationSheet.toggle()
            }) {
                Text("View")
                    .foregroundStyle(Color.primary)
            }
        }
    }
    
    var body: some View {
        Color.clear.frame(height: 40)
            .id("AnsweredIssueSection.Top")
        
        VStack(alignment: .leading, spacing: 20) {
            titleView
            NewsPaperDivider.horizontal
            
            if !result.resultText.isEmpty {
                Text(result.resultText)
                    .font(.callout)
                    .padding(.vertical)
            }
            
            if !result.headlines.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    NewsPaperDivider.horizontal
                    Text("Headlines")
                        .font(.title3)
                        .bold()
                    ForEach(result.headlines, id: \.self) { headline in
                        if !headline.isEmpty, !headline.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            HStack {
                                NewsPaperDivider.vertical
                                
                                Text(headline)
                                    .font(.title3)
                                    .italic()
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.leading)
                        }
                    }
                }
            }
            
            if !result.reclassifications.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    NewsPaperDivider.horizontal
                    Text("Classifications")
                        .font(.title3)
                        .bold()
                    
                    ForEach(result.reclassifications, id: \.self) { classify in
                        Text("\(classify.scale.name): *\(classify.from)* to *\(classify.to)*")
                    }
                }
            }
            
            if !result.rankings.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    NewsPaperDivider.horizontal
                    Text("Rankings")
                        .font(.title3)
                        .bold()
                    ForEach(sortedRankings, id: \.self) { ranking in
                        RankingView(ranking: ranking)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .padding(.top, 40)
        .sheet(isPresented: $showsLegislationSheet) {
            List {
                Section {
                    OptionView(option: result.choice)
                }
            }
        }
        .background {
            ZStack {
                Color(UIColor.systemBackground)
                    .shadow(radius: 5)
                VStack {
                    HStack {
                        Spacer()
                        Capsule()
                            .trim(from: 0.4, to: 1)
                            .stroke(Color.gray.opacity(0.9), lineWidth: 4)
                            .frame(width: 20, height: 100)
                            .offset(x: -20, y: -50)
                            .overlay {
                                Capsule()
                                .trim(from: 0.4, to: 1)
                                .stroke(Color.gray, lineWidth: 4)
                                .frame(width: 28, height: 80)
                                .offset(x: 16, y: 40)
                                .rotationEffect(.degrees(180))
                            }
                            .rotationEffect(.degrees(20))
                    }
                    .padding(.trailing)
                    Spacer()
                }
            }
                        
        }
        
    }
}

#if DEBUG
struct AnsweredIssueSection_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AnsweredIssueSection(result: .filler)
        }
        .background(Image("PaperTexture"))
        .padding()
    }
}
#endif
