//
//  NewsPaperDivider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 20/06/2025.
//

import SwiftUI

enum NewsPaperDivider {
    static var horizontal: some View {
        Color.primary.frame(height: 1)
    }
    
    static var vertical: some View {
        Color.primary.frame(width: 1)
    }
}
