//
//  InformationText.swift
//  IssuesExtensionExtension
//
//  Created by Bart Kneepkens on 17/11/2020.
//

import SwiftUI
import WidgetKit

struct InformationText: View {
    var entry: Provider.Entry
    
    var formatter: DateFormatter {
        let format = DateFormatter()
        format.timeStyle = .short
        return format
    }
    
    var body: some View {
        if entry.isSignedOut == true {
            Divider()
            Text("Please sign to find your issues here")
                .fontWeight(.medium)
        } else if entry.fetchIssuesResult.isAwaitingNextIssue {
            Divider()
            Text("Next issue at \(formatter.string(from: entry.fetchIssuesResult.nextIssueDate))")
                .fontWeight(.medium)
        }
    }
}

struct InformationText_Previews: PreviewProvider {
    static var previews: some View {
        InformationText(entry: .filler(nationName: "Elest Adra"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
