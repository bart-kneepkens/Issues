//
//  ContentView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 07/10/2020.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        NavigationView {
            if viewModel.state == ContentViewModelState.signedIn {
                IssuesView(viewModel: self.viewModel.issuesViewModel)
            } else if viewModel.state == ContentViewModelState.signingIn {
                ProgressView("Signing in..")
            } else {
                SignInView(viewModel: self.viewModel.signInViewModel)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            self.viewModel.onAppear()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}
