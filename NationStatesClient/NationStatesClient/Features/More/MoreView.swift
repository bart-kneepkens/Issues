//
//  MoreView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 26/05/2022.
//

import SwiftUI

struct MoreView: View {
    
    @StateObject var viewModel: MoreViewModel
    
    private var contactSection: some View {
        Section {
            NavigationLink {
                FeedbackIntroductionView()
            } label: {
                Label("Share Feedback", systemImage: "envelope")
            }
        } header: {
            Text("Feedback")
        }
    }
    
    private var accountSection: some View {
        Section(header: Text("Account")) {
            Button("Sign out \(self.viewModel.name)") {
                DispatchQueue.main.async {
                    self.viewModel.signOut()
                }
            }.foregroundColor(.red)
        }
    }
    
    var body: some View {
        List {
            contactSection
            accountSection
        }
        .navigationTitle("More")
    }
}

#if DEBUG
struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView(viewModel: .init(nation: .filler))
    }
}
#endif
