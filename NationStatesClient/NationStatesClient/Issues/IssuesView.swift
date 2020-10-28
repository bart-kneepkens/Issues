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
    
    var errorView: some View {
        if let error = self.viewModel.error {
            return AnyView(
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                    Text(error.text)
                }
            )
        }
        return AnyView(EmptyView())
    }
    
    var body: some View {
        List {
            Section(header: EmptyView(), footer: errorView) {
                ForEach(viewModel.issues, id: \.id) { issue in
                    NavigationLink(issue.title, destination: IssueDetailView(viewModel: .init(issue, provider: self.viewModel.provider)))
                }
            }
            .redacted(reason: self.viewModel.isFetchingIssues ? .placeholder : [])
            fetchingIndicator
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Issues")
        .navigationBarItems(trailing: NavigationLink(
                                destination: NationView(),
                                label: {
                                    Image(systemName: "gear")
                                }))
        .onAppear {
            self.viewModel.initialize()
        }
    }
}
//
//struct IssuesView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            IssuesView(viewModel: IssuesViewModel(provider: MaterializedProvider()))
//        }
//    }
//}
