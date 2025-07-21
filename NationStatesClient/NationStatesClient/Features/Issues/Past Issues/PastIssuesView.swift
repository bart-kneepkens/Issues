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
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State var selectedIssueOverlay: CompletedIssue?
    
    var body: some View {
        ScrollView(.vertical) {
            ForEach(completedIssues.reversed(), id: \.issue.id) { completed in
                Button(action: {
                    var transaction = Transaction()
                    transaction.disablesAnimations = true

                    withTransaction(transaction) {
                        selectedIssueOverlay = completed
                    }
                }) {
                    IssueCardView(viewModel: viewModelFactory.issueDetailViewModel(for: completed), isCompact: true)
                        .padding()
                        .shadow(radius: 2)
                        .background {
                            Image("PaperTexture")
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .padding()
                                .offset(x: 5, y: 10)
                                .shadow(radius: 5, x: 5, y: 5)
                        }
                }
                
            }
        }
        .navigationTitle("Past Issues")
        .background {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
        }
        .fullScreenCover(item: $selectedIssueOverlay) { issue in
            IssueDetailView(
                viewModel: viewModelFactory.issueDetailViewModel(for: issue)
            )
            .presentationBackground(.clear)
        }
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
