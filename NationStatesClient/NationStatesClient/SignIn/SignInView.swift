//
//  SignInView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel: SignInViewModel
    
    var body: some View {
        ZStack {
            Form {
                Section {
                    Text("Welcome to Issues, an unofficial NationStates client for iOS!")
                }
                Section {
                    TextField("Nation name", text: $viewModel.nationName)
                    SecureField("Password", text: $viewModel.password)
                }
                Section {
                    Button("Sign In") {
                        viewModel.attemptSignIn()
                    }
                }
            }
            NavigationLink(
                destination: IssuesView(viewModel: IssuesViewModel(service: viewModel.issuesService)).navigationBarBackButtonHidden(true),
                isActive: $viewModel.shouldNavigateForward,
                label: {
                    EmptyView()
                })
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var viewModel = SignInViewModel(service: IssuesService())
    static var previews: some View {
        SignInView(viewModel: viewModel)
    }
}
