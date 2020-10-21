//
//  IssuesView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import SwiftUI

struct IssuesView: View {
    @ObservedObject var service: IssuesService
    
    var errorView: some View {
        if let error = self.service.error {
            return AnyView(
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .frame(height: 22)
                        .aspectRatio(1, contentMode: .fit)
                    Text(error.text)
                }
            )
        }
        return AnyView(EmptyView())
    }
    
    var body: some View {
        Group {
            List {
                if service.fetchingIssues {
                    ProgressView()
                } else {
                    Section(header: EmptyView(), footer: errorView) {
                        ForEach(service.issues, id: \.id) { issue in
                            NavigationLink(issue.title, destination: IssueDetailView(viewModel: IssueDetailViewModel(issue, service: service)))
                        }
                    }
                }
            }.listStyle(InsetGroupedListStyle())
        }
        .navigationTitle("Issues")
    }
}

struct IssuesView_Previews: PreviewProvider {
    static var viewModel = IssuesViewModel(service: IssuesService())
    
    static var previews: some View {
        NavigationView {
            IssuesView(service: IssuesService())
        }
    }
}
