//
//  ContentView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 07/10/2020.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewViewModel()
    var issuesService = IssuesService()
    
    var body: some View {
        NavigationView {
            if viewModel.canPerformSilentLogin {
                IssuesView(service: self.issuesService)
            } else {
                SignInView(viewModel: SignInViewModel(service: self.issuesService))
            }
        }.onAppear {
            if viewModel.canPerformSilentLogin {
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
