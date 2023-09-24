//
//  MissingFlagView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 24/09/2023.
//

import SwiftUI

struct MissingFlagView: View {
    var body: some View {
        Rectangle()
            .stroke(lineWidth: 1)
            .fill(Color.secondary)
            .frame(width: 102, height: 64)
            .overlay {
                Image(systemName: "flag.slash")
                    .foregroundColor(Color.accentColor)
            }
    }
}

struct MissingFlagView_Previews: PreviewProvider {
    static var previews: some View {
        MissingFlagView()
    }
}
