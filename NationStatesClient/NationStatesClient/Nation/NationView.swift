//
//  NationView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 24/10/2020.
//

import SwiftUI

// TODO: add proper model / viewmodel
struct NationView: View {
    var body: some View {
        List {
            Section(header: Text("Nation Name")) {
                Text("Elest Adra")
            }
            Section(header: Text("Account")) {
                Button("Sign out") {
                    Authentication.shared.clear()
                }.foregroundColor(.red)
            }
        }.listStyle(InsetGroupedListStyle())
    }
}

struct NationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NationView()
        }
    }
}
