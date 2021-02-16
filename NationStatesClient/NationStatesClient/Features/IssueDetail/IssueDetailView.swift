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
    
    private var contents: some View {
        Group {
            if viewModel.isAnsweringIssue && viewModel.answeredIssueResult == nil {
                ProgressView()
            } else if let result = viewModel.answeredIssueResult {
                AnsweredIssueSection(result: result)
            } else {
                Button(action: {
                    showingOptions.toggle()
                }) {
                    Text("Respond to this issue").fontWeight(.medium)
                }
            }
        }
    }
    
    private var shouldShowAlert: Binding<Bool> {
        Binding(
            get: { self.viewModel.error != nil },
            set: { print($0) }
        )
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
        .alert(isPresented: self.shouldShowAlert, content: {
            Alert(title: Text("Something went wrong"), message: Text("Please try again later"), dismissButton: nil)
        })
    }
}
