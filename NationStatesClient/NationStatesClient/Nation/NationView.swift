//
//  NationView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 24/10/2020.
//

import SwiftUI

struct NationView: View {
    @Environment(\.presentationMode) var presentationMode
    let viewModel: NationViewModel
    
    var body: some View {
        List {
            Section(header: Text("Nation Name")) {
                Text("Elest Adra")
            }
            Section(header: Text("Account")) {
                Button("Sign out") {
                    presentationMode.wrappedValue.dismiss()
                    self.viewModel.signOut()
                }.foregroundColor(.red)
            }
        }.listStyle(InsetGroupedListStyle())
    }
}

struct NationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NationView(viewModel: .init(authenticationContainer: .init()))
        }
    }
}
