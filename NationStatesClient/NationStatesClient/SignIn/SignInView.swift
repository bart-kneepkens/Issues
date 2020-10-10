//
//  SignInView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel: SignInViewModel
    @ObservedObject var issuesService = IssuesService.shared
    
    let canNavigateForwardBinding: Binding<Bool> = Binding {
        IssuesService.shared.issues.count > 1
    } set: { _ in
        
    }

    
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
                destination: IssuesView(viewModel: IssuesViewModel()).navigationBarBackButtonHidden(true),
                isActive: canNavigateForwardBinding,
                label: {
                    EmptyView()
                })
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var viewModel = SignInViewModel()
    static var previews: some View {
        SignInView(viewModel: viewModel)
    }
}
