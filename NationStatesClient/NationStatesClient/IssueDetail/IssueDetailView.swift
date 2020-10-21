//
//  IssueDetailView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import SwiftUI

struct IssueDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: IssueDetailViewModel
    @State var showingOptions = false
    
    var contents: some View {
        if viewModel.answeringIssue && viewModel.answeredIssueResult.isEmpty {
            return AnyView(ProgressView())
        } else if !viewModel.answeredIssueResult.isEmpty {
            return AnyView(Text(viewModel.answeredIssueResult))
        } else {
            return AnyView(Button("Respond to this issue") {
                showingOptions.toggle()
            })
        }
    }
    
    var body: some View { 
        VStack {
            List {
                Section {
                    VStack {
                        HStack {
                            Text(viewModel.issue.title).font(.system(size: 24, weight: .bold))
                            Spacer()
                        }
                        
                        RemoteImage(url: URLBuilder.imageUrl(for: viewModel.issue.imageName)).aspectRatio(contentMode: .fit)
                        
                        Text(viewModel.issue.text)
                    }
                }
                
                Section {
                    contents
                }
            }
            .listStyle(InsetGroupedListStyle())
            .sheet(isPresented: $showingOptions, content: {
                IssueDetailOptionsView(viewModel: self.viewModel)
            })
        }
        .navigationTitle("\(Authentication.shared.nationName ?? "") Issue #\(viewModel.issue.id)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct IssueDetailView_Previews: PreviewProvider {
    static var viewModel = IssueDetailViewModel(Issue.filler, service: IssuesService())
    static var previews: some View {
        NavigationView {
            IssueDetailView(viewModel: viewModel)
        }
    }
}
