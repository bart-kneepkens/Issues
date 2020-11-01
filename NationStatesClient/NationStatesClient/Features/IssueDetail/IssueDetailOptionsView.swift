//
//  IssueDetailOptionsView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 17/10/2020.
//

import SwiftUI

struct IssueDetailOptionsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var viewModel: IssueDetailViewModel
    
    @State var selectedOption: Option? = nil
    @State var isDismissing = false
    
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
                .alert(item: $selectedOption) { option -> Alert in
                    Alert(title: Text("Accept position #\(option.id + 1)?"),
                          primaryButton: .cancel(),
                          secondaryButton: .default(Text("Accept")) {
                            presentationMode.wrappedValue.dismiss()
                            viewModel.answer(with: option)
                          })
                }
            }
            Section {
                Button("Dismiss this issue") {
                    self.isDismissing.toggle()
                }.foregroundColor(.red)
            }
            .alert(isPresented: $isDismissing, content: {
                Alert(title: Text("Dismiss issue?"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Dismiss")){
                    presentationMode.wrappedValue.dismiss()
                    viewModel.answer(with: Option.dismiss)
                })
            })
        }
        .listStyle(InsetGroupedListStyle())
    }
}

//struct IssueDetailOptionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        IssueDetailOptionsView(viewModel: .init(.filler, provider: MaterializedProvider()))
//    }
//}
