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
    
    private var fetchingIndicator: some View {
        Group {
            if self.viewModel.selectedIssuesList == .current {
                if self.viewModel.isFetchingIssues {
                    Section {
                        ProgressView()
                    }
                }
            }
            
        }
    }
    
    private var footerView: some View {
        Group {
            if self.viewModel.selectedIssuesList == .current {
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
            } else {
                Text("Completed issues appear here as you pass legislations. Keep in mind that issues completed in other apps, or on the NationStates website, do not appear here.")
            }
        }
    }
    
    private var segmentedPicker: some View {
        Picker(selection: $viewModel.selectedIssuesList, label: EmptyView(), content:{
            Text("Current").tag(IssuesListType.current).textCase(.none)
            Text("Past").tag(IssuesListType.past).textCase(.none)
        })
        .pickerStyle(SegmentedPickerStyle())
        .padding(.bottom)
    }
    
    private var listContents: some View {
        Group {
            if self.viewModel.selectedIssuesList == .current {
                ForEach(viewModel.issues, id: \.id) { issue in
                    NavigationLink(issue.title, destination: IssueDetailView(viewModel: viewModelFactory.issueDetailViewModel(for: issue, with: self.viewModel)) )
                }
            } else {
                ForEach(viewModel.completedIssues, id: \.issue.id) { completed in
                    NavigationLink(completed.issue.title, destination: IssueDetailView(viewModel: viewModelFactory.issueDetailViewModel(for: completed)))
                }
            }
        }
    }
    
    var body: some View {
        List {
            Section(header: segmentedPicker, footer: footerView) {
                listContents
            }
            
            fetchingIndicator
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Issues")
        .onAppear {
            self.viewModel.startFetchingIssues() // Throttled accordingly in VM
            self.viewModel.startRefreshingTimer()
        }
    }
}

#if DEBUG
struct IssuesView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            IssuesView(viewModel: IssuesViewModel(provider: MockedIssueProvider(), completedIssueProvider: MockedCompletedIssueProvider(), authenticationContainer: .init()))
        }
    }
}
#endif
