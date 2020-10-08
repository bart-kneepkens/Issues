//
//  IssuesView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import SwiftUI

struct IssuesView: View {
    @ObservedObject var viewModel: IssuesViewModel
    
    var body: some View {
        List(viewModel.issues, id: \.id) { issue in
            NavigationLink(issue.title, destination: IssueDetailView(viewModel: IssueDetailViewModel(issue)))
        }.navigationTitle("Issues")
    }
}

struct IssuesView_Previews: PreviewProvider {
    static var viewModel = IssuesViewModel()
    
    static var previews: some View {
        NavigationView {
            IssuesView(viewModel: viewModel)
        }
    }
}
