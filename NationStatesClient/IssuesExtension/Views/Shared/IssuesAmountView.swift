//
//  IssuesAmountView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 15/11/2020.
//

import SwiftUI
import WidgetKit

struct IssuesAmountView: View {
    let amount: Int
    var body: some View {
        ZStack {
            Image(systemName: "newspaper").resizable().frame(width: 40, height: 40, alignment: .center)
            
            Circle().foregroundColor(.red)
                .overlay(Text("\(amount)").font(.headline))
                .frame(width: 30, height: 30, alignment: .center)
                .offset(x: 20, y: -20)
        }
    }
}

struct IssuesAmountView_Previews: PreviewProvider {
    static var previews: some View {
        IssuesAmountView(amount: 5).previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
