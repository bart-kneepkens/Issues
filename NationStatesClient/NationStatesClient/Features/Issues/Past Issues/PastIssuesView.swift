//
//  PastIssuesView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 27/08/2023.
//

import SwiftUI

struct PastIssuesView: View {
    let viewModelFactory: ViewModelFactory
    let completedIssues: [CompletedIssue]
    
    var body: some View {
        List {
            Section(footer: footer) {
                ForEach(completedIssues.reversed(), id: \.issue.id) { completed in
                    NavigationLink(completed.issue.title,
                                   destination:
                                    IssueDetailView(
                                        viewModel: viewModelFactory.issueDetailViewModel(for: completed)
                                    )
                    )
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Past Issues")
    }
    
    private var footer: some View {
        Text("Completed issues appear here as you pass legislations. Keep in mind that issues completed in other apps, or on the NationStates website, do not appear here.")
    }
}

#if DEBUG
struct PastIssuesView_Previews: PreviewProvider {
    static var previews: some View {
        PastIssuesView(viewModelFactory: .init(), completedIssues: [.init(issue: .filler(), result: .filler)])
    }
}
#endif
