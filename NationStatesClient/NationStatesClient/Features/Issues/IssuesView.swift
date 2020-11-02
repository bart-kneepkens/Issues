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
    
    var fetchingIndicator: some View {
        Group {
            if self.viewModel.isFetchingIssues {
                Section {
                    ProgressView()
                }
            } else {
                EmptyView()
            }
        }
    }
    
    
    var footerView: some View {
        Group {
            if let error = self.viewModel.error {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                    Text(error.text)
                }
            } else if let result = self.viewModel.fetchIssuesResult {
                HStack {
                    Text("Next issue \(result.timeLeftForNextIssue)")
                }
            }
        }
    }
    
    var body: some View {
        List {
            Section(header: EmptyView(), footer: footerView) {
                ForEach(viewModel.issues, id: \.id) { issue in
                    NavigationLink(issue.title, destination: IssueDetailView(viewModel: self.viewModel.issueDetailViewModel(issue: issue)))
                }
            }
            .redacted(reason: self.viewModel.isFetchingIssues ? .placeholder : [])
            fetchingIndicator
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Issues")
        .navigationBarItems(trailing: NavigationLink(
                                destination: NationView(viewModel: self.viewModel.nationViewModel),
                                label: {
                                    Image(systemName: "gear")
                                }))
        .onAppear {
            self.viewModel.initialize()
        }
    }
}

struct IssuesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IssuesView(viewModel: IssuesViewModel(provider: MockedIssueProvider(), authenticationContainer: .init()))
        }
    }
}
