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
    @EnvironmentObject var deeplinkHandler: DeeplinkHandler
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
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
                try? await viewModel.refreshIssuesManually()
            }
            .navigationTitle("Issues")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing: pastIssuesButton)
            .onAppear {
                viewModel.updateIssues() // Throttled accordingly in VM
            }
            .navigationDestination(for: Issue.self) { issue in
                IssueDetailView(
                    viewModel: viewModelFactory.issueDetailViewModel(for: issue, with: viewModel)
                )
            }
            .onOpenURL { url in
                deeplinkHandler.handle(url: url)
            }
            .task(id: deeplinkHandler.activeLink) {
                guard let link = deeplinkHandler.activeLink else { return }
                do {
                    try viewModel.resolveIssueDeeplink(link: link)
                } catch {
                    if case DeeplinkError.needsToBeDeferred = error {
                        viewModel.deferredLink = link
                    }
                }
                
                deeplinkHandler.activeLink = nil
            }
        }
    }
    
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
