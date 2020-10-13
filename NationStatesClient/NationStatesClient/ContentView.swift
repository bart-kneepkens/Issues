//
//  ContentView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 07/10/2020.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewViewModel()
    
    var body: some View {
        NavigationView {
            if viewModel.canPerformSilentLogin {
                IssuesView(viewModel: IssuesViewModel())
            } else {
                SignInView(viewModel: SignInViewModel())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
