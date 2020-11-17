//
//  LargeExtensionView.swift
//  IssuesExtensionExtension
//
//  Created by Bart Kneepkens on 15/11/2020.
//

import SwiftUI
import WidgetKit

struct LargeExtensionView: View {
    var entry: IssuesEntry
    
    var body: some View {
        ZStack {
            Image("f1_square").resizable().overlay(Color("BackgroundOverlayColor"))
            VStack {
                HStack {
                    VStack {
                        Text("\(entry.fetchIssuesResult .issues.count)").font(.title).fontWeight(.bold)
                        Text(entry.nationName)
                    }
                    Spacer()
                    Image(systemName: "newspaper").resizable().frame(width: 33, height: 33)
                }
                .padding(.horizontal)
                
                Divider()
                
                IssuesList(issues: entry.fetchIssuesResult.issues)
                Spacer()
                NextIssueText(entry: self.entry)
            }.padding()
        }
    }
}

struct LargeExtensionView_Previews: PreviewProvider {
    static var previews: some View {
        LargeExtensionView(entry: .init(date: Date(), fetchIssuesResult: .filler, nationName: "Elest Adra"))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
