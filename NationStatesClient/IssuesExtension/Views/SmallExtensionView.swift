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
    
    var issueWithShortestTitle: Issue? {
        entry.fetchIssuesResult.issues.sorted(by: { $0.title.count < $1.title.count }).first
    }

    var body: some View {
        VStack {
            HStack {
                NationIssuesView(entry: entry)
                Spacer()
            }
            
            if let firstIssue = self.issueWithShortestTitle {
                Spacer()
                Text(firstIssue.title).multilineTextAlignment(.leading)
            }
            
            Spacer()
            InformationText(entry: self.entry).layoutPriority(1)
        }
        .padding()
        .widgetBackground(Image("background_small").resizable().overlay(Color("BackgroundOverlayColor")))
    }
}

#if DEBUG
struct SmallExtensionView_Previews: PreviewProvider {
    static var previews: some View {
        SmallExtensionView(entry: .filler(nationName: "Elest Adra")).previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
#endif
