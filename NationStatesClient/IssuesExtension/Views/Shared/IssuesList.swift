//
//  IssuesList.swift
//  IssuesExtensionExtension
//
//  Created by Bart Kneepkens on 15/11/2020.
//

import SwiftUI

struct IssuesList: View {
    let issues: [Issue]
    let maximumAmountIssuesToShow: Int
    
    init(issues: [Issue], maximumAmountIssuesToShow: Int = 5) {
        self.issues = issues
        self.maximumAmountIssuesToShow = maximumAmountIssuesToShow
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(self.issues, id: \.id) { issue in
                HStack {
                    Text("\(issue.title)")
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 4)
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
        IssuesList(issues: [.filler(1), .filler(2)])
    }
}
