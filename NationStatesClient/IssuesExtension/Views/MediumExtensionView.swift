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
            HStack {
                IssuesAmountView(amount: entry.fetchIssuesResult.issues.count)
                    .padding(25)
                
                VStack(spacing: 0) {
                    ForEach(entry.fetchIssuesResult.issues, id: \.id) { issue in
                        HStack {
                            Text("\(issue.title)").multilineTextAlignment(.leading).padding(.vertical, 4)
                            Spacer()
                        }
                        if issue.id != entry.fetchIssuesResult.issues.last?.id {
                            DashedLine()
                        }
                    }
                }
            }.padding(.trailing)
        }
    }
}

struct MediumExtensionView_Previews: PreviewProvider {
    static var previews: some View {
        MediumExtensionView(entry: .init(date: Date(), fetchIssuesResult: .filler, nationName: "Elest Adra"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
