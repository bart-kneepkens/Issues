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
                    HStack {
                        Image(systemName: "newspaper").resizable().frame(width: 30, height: 30)
                        Spacer()
                        Text("\(entry.fetchIssuesResult.issues.count)")
                            .font(.title2)
                            .fontWeight(.heavy)
                    }
                    Spacer()
                    Text(entry.nationName).font(.headline)
                    Spacer()
                    NextIssueText(entry: self.entry)
                }.padding()
            }
        }
    }
}

struct SmallExtensionView_Previews: PreviewProvider {
    static var previews: some View {
        SmallExtensionView(entry: .init(date: Date(), fetchIssuesResult: .filler, nationName: "Elest Adra")).previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

