//
//  IssuesView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import SwiftUI
import Combine

struct IssuesView: View {
    @StateObject var viewModel: IssuesViewModel
    @Environment(\.viewModelFactory) var viewModelFactory: ViewModelFactory
    
    @ViewBuilder private var fetchingIndicator: some View {
        if self.viewModel.isFetchingIssues {
            Section {
                ProgressView()
            }
        }
    }
    
    @ViewBuilder private var footerView: some View {
        if let error = self.viewModel.error {
            ErrorView(error: error) {
                switch error {
                case .unauthorized:
                    self.viewModel.signOut()
                default: break
                }
            }
        } else if let result = self.viewModel.fetchIssuesResult, self.viewModel.issues.count != 5 {
            Text("Next issue \(result.timeLeftForNextIssue)")
            }
    }
    
    @ViewBuilder private var deeplinkedIssueLinkContents: some View {
        if let issue = self.viewModel.deeplinkedIssue {
            IssueDetailView(viewModel: viewModelFactory.issueDetailViewModel(for: issue, with: self.viewModel))
        }
    }
    
    private var deeplinkedIssueLink: some View {
        NavigationLink(
            destination: deeplinkedIssueLinkContents, isActive: self.shouldNavigateToDeeplinkedIssue) {
            deeplinkedIssueLinkContents
        }
    }
    
    private var shouldNavigateToDeeplinkedIssue: Binding<Bool> {
        .init {
            self.viewModel.deeplinkedIssue != nil
        } set: { shouldNavigate in
            if !shouldNavigate && self.viewModel.deeplinkedIssue != nil {
                print("cleared deeplinkedIssue")
                self.viewModel.deeplinkedIssue = nil
            }
        }
    }
    
    var body: some View {
        ZStack {
            deeplinkedIssueLink
            List {
                Section(footer: footerView) {
                    ForEach(viewModel.issues, id: \.id) { issue in
                        NavigationLink(issue.title, destination: IssueDetailView(viewModel: viewModelFactory.issueDetailViewModel(for: issue, with: self.viewModel)))
                    }
                }
                
                Section {
                    fetchingIndicator
                }
            }
            .listStyle(.insetGrouped)
            .refreshable {
                viewModel.updateIssues()
            }
            .navigationTitle("Issues")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing: pastIssuesButton)
            .onAppear {
                self.viewModel.updateIssues() // Throttled accordingly in VM
                self.viewModel.startRefreshingTimer()
            }
        }
    }
    
    @ViewBuilder private var pastIssuesButton: some View {
        NavigationLink {
            PastIssuesView(viewModelFactory: viewModelFactory, completedIssues: viewModel.completedIssues)
        } label: {
            Image(systemName: "clock.arrow.circlepath")
        }
    }
}

#if DEBUG
struct IssuesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IssuesView(viewModel:
                        IssuesViewModel(provider: MockedIssueProvider(issues: [.filler()]), completedIssueProvider: MockedCompletedIssueProvider(), authenticationContainer:.init())
            )
        }
    }
}
#endif
