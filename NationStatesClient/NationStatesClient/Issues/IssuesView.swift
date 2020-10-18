//
//  IssuesView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import SwiftUI

struct IssuesView: View {
    @StateObject var viewModel: IssuesViewModel
    
    var body: some View {
        if viewModel.fetchingIssues {
            ProgressView()
        } else {
            List(viewModel.issues, id: \.id) { issue in
                NavigationLink(issue.title, destination: IssueDetailView(viewModel: IssueDetailViewModel(issue, service: viewModel.service)))
            }
            .navigationTitle("Issues")
        }
    }
}

struct IssuesView_Previews: PreviewProvider {
    static var viewModel = IssuesViewModel(service: IssuesService())
    
    static var previews: some View {
        NavigationView {
            IssuesView(viewModel: viewModel)
        }
    }
}
