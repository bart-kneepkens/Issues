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
        Image(systemName: self.iconName)
    }
    
    var body: some View {
        HStack {
            Text(self.ranking.scale.name)
            Spacer()
            icon
            Text("\(String(format: "%.2f", self.ranking.percentualChange))%")
                .foregroundColor(tintColor)
                .font(.callout)
        }
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView(ranking: .init(scale: CensusScale.unknown, score: 1, change: 0.001, percentualChange: 2))
    }
}
