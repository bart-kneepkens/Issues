//
//  IssueDetailOptionsView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 17/10/2020.
//

import SwiftUI

struct IssueDetailOptionsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var selectedOption: Option? = nil
    @State var intendsToDismiss = false
    
    var viewModel: IssueDetailViewModel
    
    var body: some View {
        NavigationStack {
                List(viewModel.issue.options, id: \.self, selection: $selectedOption) { option in
                        Section {
                            OptionView(option: option)
                        }
                }
                .toolbarTitleDisplayMode(.inline)
                .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    if intendsToDismiss && selectedOption == nil {
                        Button {
                            confirmOption(.dismiss)
                        } label: {
                            HStack {
                                Image(systemName: "nosign")
                                Text("Dismiss Issue?")
                            }
                            .bold()
                            .foregroundStyle(Color.red)
                        }
                    } else {
                        Button {
                            withAnimation {
                                intendsToDismiss = true
                                selectedOption = nil
                            }
                        } label: {
                            Image(systemName: "nosign")
                        }
                    }
                    
                    if let selectedOption {
                        Spacer()
                        confirmButton(option: selectedOption)
                    }
                }
                
            }
        }
    }
    
    private func confirmButton(option: Option) -> some View {
        if #available(iOS 26.0, *) {
            Button(role: .confirm) {
                confirmOption(option)
            } label: {
                Text("Accept position #\(option.id + 1)")
                    .bold()
            }
        } else {
            Button {
                confirmOption(option)
            } label: {
                Text("Accept position #\(option.id + 1)")
                    .bold()
                    .foregroundStyle(Color.accentColor)
            }
        }
    }
    
    private func confirmOption(_ option: Option) {
        viewModel.answer(with: option)
        dismiss()
    }
}

struct OptionView: View {
    
    let option: Option
    
    var body: some View {
        HStack {
            Text(String(option.id + 1))
                .font(.caption)
            
            Rectangle()
                .fill(Color.primary)
                .frame(width: 0.5)
            
            Text(option.text)
                .font(.callout)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical)
    }
}

#if DEBUG
struct IssueDetailOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        Color.red
            .sheet(isPresented: .constant(true)) {
                IssueDetailOptionsView(viewModel: IssueDetailViewModel(completedIssue: CompletedIssue(issue: .filler(), result: .filler), nationDetailsProvider: MockedNationDetailsProvider(), nationName: "elest_adra"))
                    .presentationDetents([.large])
            }
    }
}
#endif
