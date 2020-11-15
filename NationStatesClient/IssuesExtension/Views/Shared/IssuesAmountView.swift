//
//  IssuesAmountView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 15/11/2020.
//

import SwiftUI

struct IssuesAmountView: View {
    let amount: Int
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "newspaper").resizable().frame(width: 40, height: 40, alignment: .center)
                Text("ISSUES")
            }
            
            Circle().foregroundColor(.red)
                .overlay(Text("\(amount)").font(.headline))
                .frame(width: 30, height: 30, alignment: .center)
                .offset(x: 20, y: -35)
        }
    }
}

struct IssuesAmountView_Previews: PreviewProvider {
    static var previews: some View {
        IssuesAmountView(amount: 5)
    }
}
