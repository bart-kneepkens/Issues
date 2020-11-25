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
        Group {
            if viewModel.isAnsweringIssue && viewModel.answeredIssueResult == nil {
                ProgressView()
            } else if let result = viewModel.answeredIssueResult {
                IssueAnsweredSection(result: result)
            } else {
                Button("Respond to this issue") {
                    showingOptions.toggle()
                }
            }
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
                    
                    CachedRemoteImage(url: URLBuilder.imageUrl(for: viewModel.issue.imageName)).aspectRatio(contentMode: .fit)
                    
                    Text(viewModel.issue.text)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            contents
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("\(viewModel.nationName) Issue #\(viewModel.issue.id)")
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
