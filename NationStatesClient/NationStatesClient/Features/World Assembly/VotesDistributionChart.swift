//
//  VotesDistributionChart.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 30/12/2020.
//

import SwiftUI

struct VotesDistributionChart: View {
    let votesFor: Int
    let votesAgainst: Int
    
    private let minimumBarWidth = CGFloat(40)
    
    private var totalVotes: Int {
        votesFor + votesAgainst
    }
    
    private func widthForAmount(_ amount: Int, using geometry: GeometryProxy) -> CGFloat {
        let totalWidth = geometry.frame(in: .global).width
        let maxWidth = totalWidth - minimumBarWidth
        let ptPerVote = totalWidth / CGFloat(totalVotes)
        let calculatedWidth = CGFloat(amount) * ptPerVote
        
        if calculatedWidth > maxWidth {
            return maxWidth
        } else if calculatedWidth < minimumBarWidth {
            return minimumBarWidth
        }
        
        return calculatedWidth
    }
    
    private func text(_ votes: Int) -> some View {
        Text("\(votes)")
            .foregroundColor(.white)
            .font(.title3)
            .fontWeight(.medium)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(spacing: 0) {
                    Rectangle()
                        .overlay(text(votesFor))
                        .frame(width:widthForAmount(votesFor, using: geometry))
                        .foregroundColor(Color("PositiveBlue"))
                    
                    Rectangle()
                        .overlay(text(votesAgainst))
                        .foregroundColor(Color("NegativeRed"))
                }
                .clipShape(RoundedRectangle(cornerRadius: 13))
                HStack {
                    Text("For").bold()
                    Spacer()
                    Text("Against").bold()
                }
            }
        }
    }
}

struct VotesDistributionChart_Previews: PreviewProvider {
    static var previews: some View {
        VotesDistributionChart(votesFor: 2, votesAgainst: 4)
            .frame(height: 100)
    }
}
