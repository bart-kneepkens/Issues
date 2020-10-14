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
    
    var body: some View {
        let shouldRenderCompletedView = viewModel.answeredIssueResult != nil
        
        ZStack {
            VStack {
                List {
                    VStack {
                        Text(viewModel.issue.title).font(.headline)
                        Text(viewModel.issue.text)
                    }.padding(.horizontal)
                    ForEach(viewModel.issue.options, id: \.id) { option in
                    Section {
                        Button(action: {
                            viewModel.answer(with: option)
                        }, label: {
                            Text(option.text).font(.callout)
                        }).buttonStyle(PlainButtonStyle())
                    }
                    }
                }.listStyle(InsetGroupedListStyle())
            }
            
            if shouldRenderCompletedView {
                Color.black.opacity(0.3)
                VStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .padding()
                            .foregroundColor(Color(UIColor.secondarySystemBackground))
                        
                        VStack {
                            Text(viewModel.answeredIssueResult ?? "Result")
                            Button("Bye") {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }.frame(height: 300)
                }
            }
        }
        .navigationTitle("Issue #\(viewModel.issue.id)")
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
