//
//  IssueDetailView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import SwiftUI

struct IssueDetailView: View {
    @ObservedObject var viewModel: IssueDetailViewModel
    
    var body: some View {
        ScrollView {
            Text(viewModel.issue.text)
            ForEach(viewModel.issue.options, id: \.id) { option in
                Divider()
                Button(action: {
                    viewModel.answer(with: option)
                }, label: {
                    Text(option.text).font(.callout)
                }).buttonStyle(PlainButtonStyle())
            }.padding(.horizontal)
        }
        .navigationTitle(viewModel.issue.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct IssueDetailView_Previews: PreviewProvider {
    static var viewModel = IssueDetailViewModel(Issue.filler)
    static var previews: some View {
        NavigationView {
            IssueDetailView(viewModel: viewModel)
        }
    }
}
