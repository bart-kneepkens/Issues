//
//  ColoredFreedomText.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 27/12/2020.
//

import SwiftUI

fileprivate let COLORS = [
    0xb71c1c,
    0xBF360C,
    0xD84315,
    0xEF6C00,
    0xF57C00,
    0xFF8F00,
    0xFFA000,
    0xAFB42B,
    0xC0CA33,
    0x9E9D24,
    0x689F38,
    0x43A047,
    0x388E3C,
    0x2E7D32,
    0x1B5E20,
]

struct ColoredFreedomText: View {
    let freedom: Freedom

    private var colorIndex: Int {
        min(max(Int(freedom.score) / 7, 0), COLORS.count - 1)
    }
    
    private var color: Color {
        guard let uiColor = UIColor(rgb: COLORS[colorIndex]) else { return .black }
        return Color(uiColor)
    }
    
    var body: some View {
        Text("\(freedom.text) (\(Int(freedom.score)))")
            .foregroundColor(self.color)
            .fontWeight(.medium)
    }
}

struct ColoredFreedomText_Previews: PreviewProvider {
    static var previews: some View {
        ColoredFreedomText(freedom: .init(score: 1, rank: 1, regionRank: 1, text: "Superb"))
    }
}
