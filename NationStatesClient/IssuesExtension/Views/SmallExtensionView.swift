//
//  SmallExtensionView.swift
//  IssuesExtensionExtension
//
//  Created by Bart Kneepkens on 15/11/2020.
//

import SwiftUI
import WidgetKit

struct SmallExtensionView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            ZStack {
                Image("f1_square").resizable().overlay(Color("BackgroundOverlayColor"))
                VStack {
                    IssuesAmountView(amount: entry.fetchIssuesResult.issues.count)
                    Text(entry.fetchIssuesResult.timeLeftForNextIssue.uppercased())
                }
            }
        }
    }
}

struct SmallExtensionView_Previews: PreviewProvider {
    static var previews: some View {
        SmallExtensionView(entry: .init(date: Date(), fetchIssuesResult: .filler, nationName: "Elest Adra")).previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
    
