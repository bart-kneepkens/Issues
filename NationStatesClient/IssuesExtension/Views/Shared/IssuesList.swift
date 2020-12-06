//
//  IssuesList.swift
//  IssuesExtensionExtension
//
//  Created by Bart Kneepkens on 15/11/2020.
//

import SwiftUI
import WidgetKit

struct IssuesList: View {
    let issues: [Issue]
    
    init(issues: [Issue], maximumAmountIssuesToShow: Int = 5) {
        guard issues.count > maximumAmountIssuesToShow else {
            self.issues = issues
            return
        }
        
        self.issues = Array(issues[0..<maximumAmountIssuesToShow])
        
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(self.issues, id: \.id) { issue in
                HStack {
                    Text("\(issue.title)")
                        .multilineTextAlignment(.leading)
                        .frame(maxHeight: 44, alignment: .center)
                    Spacer()
                }
                if issue.id != self.issues.last?.id {
                    Divider()
                }
            }
        }
    }
}

struct IssuesList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IssuesList(issues: [.filler(1), .filler(2), .filler(3), .filler(4), .filler(5)]).previewContext(WidgetPreviewContext(family: .systemLarge))
            
            IssuesList(issues: [.filler(1), .filler(2), .filler(3), ]).previewContext(WidgetPreviewContext(family: .systemMedium))
            
            IssuesList(issues: [.filler(1), .filler(2), .filler(3), ]).previewContext(WidgetPreviewContext(family: .systemLarge))
        }
        
    }
}
