//
//  RankingView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 18/12/2020.
//

import SwiftUI

struct RankingView: View {
    let ranking: Ranking
    
    private var iconName: String {
        return self.ranking.percentualChange > 0 ? "arrow.up.right" : "arrow.down.right"
    }
    
    private var tintColor: Color {
        return self.ranking.percentualChange > 0 ? .green : .red
    }
    
    var icon: some View {
        Image(systemName: iconName)
            .bold()
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: .zero) {
            Text(self.ranking.scale.name)
//            Spacer()
//            Text("..................................")
//            NewsPaperDivider.horizontal
//                .padding(.bottom, 8)
            Rectangle()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                .frame(height: 1)
                .padding(8)
                
            HStack {
                icon
                Text("\(String(format: "%.2f", self.ranking.percentualChange))%")
                    .font(.callout)
                    
            }
//            .padding(12)
            .foregroundStyle(tintColor)
//            .background(Capsule().fill(tintColor))
        }
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView(ranking: .init(scale: CensusScale.unknown, score: 1, change: 0.001, percentualChange: 2))
    }
}
