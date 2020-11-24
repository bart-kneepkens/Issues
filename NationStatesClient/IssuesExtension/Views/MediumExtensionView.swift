//
//  MediumExtensionView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 15/11/2020.
//

import WidgetKit
import SwiftUI

struct MediumExtensionView: View {
    var entry: IssuesEntry
    
    var body: some View {
        ZStack {
            Image("f1_landscape").resizable().overlay(Color("BackgroundOverlayColor"))
            VStack {
                HStack {
                    IssuesAmountView(amount: entry.fetchIssuesResult.issues.count)
                        .padding(25)
                    
                    IssuesList(issues: entry.fetchIssuesResult.issues)
                }.padding(.trailing)
                NextIssueText(entry: self.entry)
            }
        }
    }
}

struct MediumExtensionView_Previews: PreviewProvider {
    static var previews: some View {
        MediumExtensionView(entry: .init(date: Date(), fetchIssuesResult: .filler, nationName: "Elest Adra"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
