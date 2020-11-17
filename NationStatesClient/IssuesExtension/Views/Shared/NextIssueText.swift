//
//  NextIssueText.swift
//  IssuesExtensionExtension
//
//  Created by Bart Kneepkens on 17/11/2020.
//

import SwiftUI
import WidgetKit

struct NextIssueText: View {
    var entry: Provider.Entry
    
    var formatter: DateFormatter {
        let format = DateFormatter()
        format.timeStyle = .short
        return format
    }
    
    var body: some View {
        if entry.fetchIssuesResult.isAwaitingNextIssue {
            Text("Next issue at \(formatter.string(from: entry.fetchIssuesResult.nextIssueDate))")
        } else {
            Text("ISSUES")
        }
    }
}

struct NextIssueText_Previews: PreviewProvider {
    static var previews: some View {
        NextIssueText(entry: .init(date: Date(), fetchIssuesResult: .filler, nationName: "Elest Adraaaaa"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
