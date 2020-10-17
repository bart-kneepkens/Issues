//
//  IssueDetailOptionsView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 17/10/2020.
//

import SwiftUI

struct IssueDetailOptionsView: View {
    var viewModel: IssueDetailViewModel
    @State var selectedOption: Option? = nil
    
    var body: some View {
        List {
            ForEach(viewModel.issue.options, id: \.id) { option in
                Section {
                    Group {
                        Text(option.text).font(.callout)
                        HStack {
                            Spacer()
                            Button(action: {
                                self.selectedOption = option
                            }, label: {
                                Text("Accept")
                            })
                            Spacer()
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .alert(item: $selectedOption) { option -> Alert in
            Alert(title: Text("Accept position #\(option.id + 1)?"),
                  primaryButton: .cancel(),
                  secondaryButton: .default(Text("Accept")) {
                    viewModel.answer(with: option)
                  })
        }
    }
}

struct IssueDetailOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        IssueDetailOptionsView(viewModel: .init(Issue.filler, service: .init()))
    }
}
