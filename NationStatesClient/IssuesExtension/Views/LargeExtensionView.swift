//
//  LargeExtensionView.swift
//  IssuesExtensionExtension
//
//  Created by Bart Kneepkens on 15/11/2020.
//

import SwiftUI
import WidgetKit

struct LargeExtensionView: View {
    let entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Image("f1_square").resizable().overlay(Color("BackgroundOverlayColor"))
            VStack {
                HStack {
                    NationIssuesView(entry: entry)
                    if let name = entry.nationName {
                        Spacer()
                        Text(name).font(.headline)
                    }
                }.padding(.bottom)
                IssuesList(issues: entry.fetchIssuesResult.issues)
                Spacer()
                InformationText(entry: self.entry)
            }.padding()
        }
    }
}

#if DEBUG
struct LargeExtensionView_Previews: PreviewProvider {
    static var previews: some View {
        LargeExtensionView(entry: .filler(nationName: "Elest Adra"))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
#endif
