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
    
    var viewModel: IssueDetailViewModel
    
    var body: some View {
        VStack {
            fauxNavigationBar

            List {
                ForEach(viewModel.issue.options, id: \.id) { option in
                    Section {
                        OptionView(option: option) {
                            self.selectedOption = option
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .presentationBackground(Material.ultraThin)
        .alert(item: $selectedOption) { option -> Alert in
            Alert(
                title: Text("Accept position #\(option.id + 1)?"),
                primaryButton: .cancel(),
                secondaryButton: .default(Text("Accept")) {
                    viewModel.answer(with: option)
                    dismiss()
                }
            )
        }
    }
    
    private var fauxNavigationBar: some View{
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(Color.primary, Material.thin)
                
            }
            Spacer()
        }
        .padding([.top, .horizontal])
    }
}

struct OptionView: View {
    
    let option: Option
    let onPress: () -> Void
    
    var body: some View {
        Button(action: {
            onPress()
        }) {
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
        .buttonStyle(.plain)
    }
}

#if DEBUG
struct IssueDetailOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        Color.red
            .sheet(isPresented: .constant(true)) {
                IssueDetailOptionsView(viewModel: IssueDetailViewModel(completedIssue: CompletedIssue(issue: .filler(), result: .filler), nationDetailsProvider: MockedNationDetailsProvider(), nationName: "elest_adra"))
            }
    }
}
#endif
