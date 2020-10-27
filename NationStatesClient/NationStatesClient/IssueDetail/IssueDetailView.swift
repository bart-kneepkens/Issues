//
//  IssueDetailView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import SwiftUI

struct IssueDetailView: View {
    @StateObject var viewModel: IssueDetailViewModel
    
    @State var showingOptions = false
    
    var contents: some View {
        if viewModel.isAnsweringIssue && viewModel.answeredIssueResult == nil {
            return AnyView(ProgressView())
        } else if let result = viewModel.answeredIssueResult {
            return AnyView(IssueAnsweredSection(result: result))
        } else {
            return AnyView(Button("Respond to this issue") {
                showingOptions.toggle()
            })
        }
    }
    
    var body: some View {
        List {
            Section {
                VStack {
                    HStack {
                        Text(viewModel.issue.title).font(.system(size: 24, weight: .bold))
                        Spacer()
                    }
                    
                    RemoteImage(url: URLBuilder.imageUrl(for: viewModel.issue.imageName)).aspectRatio(contentMode: .fit)
                    
                    Text(viewModel.issue.text)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            contents
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("\(Authentication.shared.nationName ?? "") Issue #\(viewModel.issue.id)")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingOptions, content: {
            IssueDetailOptionsView(viewModel: self.viewModel)
        })
    }
}

//struct IssueDetailView_Previews: PreviewProvider {
//    static var viewModel = IssueDetailViewModel(.filler, provider: MaterializedProvider())
//    static var previews: some View {
//        NavigationView {
//            IssueDetailView(viewModel: viewModel)
//        }
//    }
//}
