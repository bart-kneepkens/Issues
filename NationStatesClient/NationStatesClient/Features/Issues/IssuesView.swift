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
    @State private var path = NavigationPath()
    @Environment(\.viewModelFactory) var viewModelFactory: ViewModelFactory
    @EnvironmentObject var deeplinkHandler: DeeplinkHandler
    
    var body: some View {
        NavigationStack(path: $path) {
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
                self.viewModel.updateIssues() // Throttled accordingly in VM
            }
            .navigationDestination(for: Issue.self) { issue in
                IssueDetailView(
                    viewModel: viewModelFactory.issueDetailViewModel(for: issue, with: viewModel)
                )
            }
            .onOpenURL { url in
                deeplinkHandler.handle(url: url)
            }
            .onReceive(deeplinkHandler.$activeLink) { link in
                guard let link else { return }
                guard case .issue(let id) = link else { return }
                guard let linkedIssue = viewModel.issues.first(where: { $0.id == id }) else { return }
                path.append(linkedIssue)
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
