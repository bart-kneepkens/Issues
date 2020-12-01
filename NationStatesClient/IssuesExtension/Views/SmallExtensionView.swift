//
//  SmallExtensionView.swift
//  IssuesExtensionExtension
//
//  Created by Bart Kneepkens on 15/11/2020.
//

import SwiftUI
import WidgetKit

struct SmallExtensionView: View {
    let entry: Provider.Entry

    var body: some View {
        VStack {
            ZStack {
                Image("f1_square").resizable().overlay(Color("BackgroundOverlayColor"))
                VStack {
                    HStack {
                        NationIssuesView(entry: entry)
                        Spacer()
                    }
                    
                    if let firstIssue = entry.fetchIssuesResult.issues.first {
                        Spacer()
                        Text(firstIssue.title).multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    InformationText(entry: self.entry).layoutPriority(1)
                }.padding()
            }
        }
    }
}

struct SmallExtensionView_Previews: PreviewProvider {
    static var previews: some View {
        SmallExtensionView(entry: .filler(nationName: "Elest Adra")).previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

