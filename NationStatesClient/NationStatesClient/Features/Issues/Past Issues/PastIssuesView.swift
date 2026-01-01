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
    
    @State var selectedIssueOverlay: CompletedIssue?
    
    var body: some View {
        ScrollView(.vertical) {
            if completedIssues.isEmpty {
                Spacer(minLength: 20)
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .font(.system(.largeTitle))
                    
                    Text("No past issues")
                        .bold()
                        .font(.title3)
                    
                    NewsPaperDivider.horizontal
                    
                    Text("Completed issues appear here as you pass legislations. Issues completed in other apps or on the NationStates website do not appear here.")
                        .multilineTextAlignment(.center)
                    
                    NewsPaperDivider.horizontal
                }
                .safeAreaPadding()
                .background {
                    Image("PaperTexture")
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                }
                .padding()
            }
            
            ForEach(completedIssues.reversed(), id: \.issue.id) { completed in
                Button {
                    selectedIssueOverlay = completed
                } label: {
                    IssueCardView(
                        viewModel: viewModelFactory.issueDetailViewModel(
                            for: completed
                        ),
                        isCompact: true
                    )
                    .padding()
                    .shadow(radius: 2)
                    .background {
                        Image("PaperTexture")
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 35))
                            .padding()
                            .offset(x: 5, y: 10)
                            .shadow(radius: 5, x: 5, y: 5)
                    }
                }
                
            }
        }
        .background {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
        }
        .sheet(item: $selectedIssueOverlay) { issue in
            IssueDetailView(
                viewModel: viewModelFactory.issueDetailViewModel(for: issue)
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}

#if DEBUG
#Preview("1 issue") {
    NavigationStack {
        PastIssuesView(
            viewModelFactory: .init(),
            completedIssues: [
                .init(
                    issue: .filler(),
                    result: .filler
                )
            ]
        )
    }
}

#Preview("0 issues") {
    NavigationStack {
        PastIssuesView(
            viewModelFactory: .init(),
            completedIssues: []
        )
    }
}
#endif
