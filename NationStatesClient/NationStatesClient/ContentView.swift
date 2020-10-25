//
//  ContentView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 07/10/2020.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var authenthication = Authentication.shared
    var issuesService = IssuesService()
    
    var body: some View {
        NavigationView {
            if authenthication.canPerformSilentLogin {
                IssuesView(service: self.issuesService)
            } else {
                SignInView(viewModel: SignInViewModel(service: self.issuesService))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            if authenthication.canPerformSilentLogin {
                self.issuesService.fetchIssues()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
