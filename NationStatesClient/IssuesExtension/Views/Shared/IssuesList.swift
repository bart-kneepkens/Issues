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
    
    @ViewBuilder private func issueView(_ issue: Issue) -> some View {
        HStack {
            Text("\(issue.title)")
                .multilineTextAlignment(.leading)
                .frame(maxHeight: 44, alignment: .center)
            Spacer()
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(self.issues, id: \.id) { issue in
                if let url = issue.deeplinkURL {
                    Link(destination: url) {
                        issueView(issue)
                    }
                } else {
                    issueView(issue)
                }
                
                if issue.id != self.issues.last?.id {
                    Divider()
                }
            }
        }
    }
}

#if DEBUG
struct IssuesList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IssuesList(issues: [.filler(1), .filler(2), .filler(3), .filler(4), .filler(5)]).previewContext(WidgetPreviewContext(family: .systemLarge))
            
            IssuesList(issues: [.filler(1), .filler(2), .filler(3), ]).previewContext(WidgetPreviewContext(family: .systemMedium))
            
            IssuesList(issues: [.filler(1), .filler(2), .filler(3), ]).previewContext(WidgetPreviewContext(family: .systemLarge))
        }
        
    }
}
#endif
