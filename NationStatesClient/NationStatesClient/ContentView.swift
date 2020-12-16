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
            if viewModel.state == ContentViewModelState.initial {
                SignInView(viewModel: self.viewModel.signInViewModel)
            } else if viewModel.state == ContentViewModelState.signingIn {
                SignInProgressView(error: viewModel.error)
            } else {
                IssuesView(viewModel: self.viewModel.issuesViewModel)
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
