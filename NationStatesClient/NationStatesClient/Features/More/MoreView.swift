//
//  MoreView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 26/05/2022.
//

import SwiftUI

struct MoreView: View {
    
    @StateObject var viewModel: MoreViewModel
    
    @State var showingFeedbackSheet = false
    
    private var contactSection: some View {
        Section {
            Button {
                showingFeedbackSheet.toggle()
            } label: {
                HStack {
                    Image(systemName: "envelope")
                    Text("Share feedback")
                }
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
        .sheet(isPresented: $showingFeedbackSheet) {
            
        } content: {
            FeedbackIntroductionView()
        }

    }
}

#if DEBUG
struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView(viewModel: .init(nation: .filler))
    }
}
#endif
