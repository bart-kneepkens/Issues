//
//  MediumExtensionView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 15/11/2020.
//

import WidgetKit
import SwiftUI

struct MediumExtensionView: View {
    let entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Image("f1_landscape").resizable().overlay(Color("BackgroundOverlayColor"))
            VStack {
                HStack {
                    VStack {
                        NationIssuesView(entry: entry)
                        Spacer()
                    }
                    IssuesList(issues: entry.fetchIssuesResult.issues, maximumAmountIssuesToShow: 3)
                }
                Spacer()
                InformationText(entry: self.entry)
            }.padding()
        }
    }
}

struct MediumExtensionView_Previews: PreviewProvider {
    static var previews: some View {
        MediumExtensionView(entry: .filler(nationName: "Elest Adra"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
