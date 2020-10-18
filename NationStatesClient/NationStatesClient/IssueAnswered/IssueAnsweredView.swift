//
//  IssueAnsweredView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 18/10/2020.
//

import SwiftUI

struct IssueAnsweredView: View {
    @ObservedObject var viewModel: IssueDetailViewModel
    
    var body: some View {
        List {
            Section {
                VStack {
                    Text(viewModel.issue.title)
                        .font(.title3)
                    RemoteImage(url: URLBuilder.imageUrl(for: viewModel.issue.imageName))
                        .aspectRatio(contentMode: .fit)
                    Text(viewModel.issue.text)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Legislation Passed")
    }
}

struct IssueAnsweredView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IssueAnsweredView(viewModel: IssueDetailViewModel(Issue.filler, service: .init()))
        }
    }
}
