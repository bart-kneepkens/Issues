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
        if viewModel.answeringIssue && viewModel.answeredIssueResponse == nil {
            return AnyView(ProgressView())
        } else if let response = viewModel.answeredIssueResponse {
            return AnyView(IssueAnsweredSection(response: response))
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
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                contents
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
        }.onAppear {
            viewModel.answeredIssueResponse = .init(
                result: "This is the result of your actions",
                rankings: [.init(id: 2, score: 2, change: 0.5, percentualChange: 0.23)],
                reclassificiations: [.init(type: 1, from: "Stronk", to: "Much Stronker")],
                headlines: ["Headline 1", "Headline 2"])
        }
    }
}
