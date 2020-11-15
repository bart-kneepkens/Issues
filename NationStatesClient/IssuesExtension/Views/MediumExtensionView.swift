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
        HStack {
            IssuesAmountView(amount: entry.issues.count)
                .padding(25)
            
            VStack(spacing: 0) {
                ForEach(entry.issues, id: \.id) { issue in
                    HStack {
                        Text("\(issue.title)").multilineTextAlignment(.leading).padding(.vertical, 4)
                        Spacer()
                    }
                    if issue.id != entry.issues.last?.id {
                        DashedLine()
                    }
                }
            }
        }.padding(.trailing)
    }
}

struct MediumExtensionView_Previews: PreviewProvider {
    static var previews: some View {
        MediumExtensionView(entry: .init(date: Date(), issues: [.filler(1), .filler(2), .filler(3), .filler(4), .filler(5)]))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
