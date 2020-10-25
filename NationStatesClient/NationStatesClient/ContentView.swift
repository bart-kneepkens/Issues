//
//  ContentView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 07/10/2020.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var authentication = Authentication.shared
    var issuesService = IssuesService()
    
    var body: some View {
        NavigationView {
            if authentication.signInSuccessful {
                IssuesView(service: self.issuesService)
            } else if authentication.isSigningIn {
                ProgressView("Signing in..")
            } else {
                SignInView(viewModel: SignInViewModel(service: self.issuesService))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onReceive(authentication.$signInSuccessful, perform: { successful in
            if successful {
                self.issuesService.fetchIssues()
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
