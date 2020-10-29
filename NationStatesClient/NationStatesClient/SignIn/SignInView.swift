//
//  SignInView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel: SignInViewModel
    @State var shouldRevealPassword = false
    
    var shouldShowAlert: Binding<Bool> {
        .init(get: { self.viewModel.signInError != nil }, set: {_ in})
    }
    
    var body: some View {
        Group {
            Form {
                Section {
                    Image("banner")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                Section {
                    Text("Welcome to Issues, an unofficial NationStates client for iOS!")
                }
                
                Section {
                    TextField("Nation name", text: $viewModel.nationName)
                    HStack {
                        if self.shouldRevealPassword {
                            TextField("Password", text: $viewModel.password)
                        } else {
                            SecureField("Password", text: $viewModel.password)
                        }
                        Button(action: {
                            self.shouldRevealPassword.toggle()
                        }, label: {
                            Image(systemName: self.shouldRevealPassword ? "eye.slash" : "eye").resizable().aspectRatio(contentMode: .fit).frame(width: 30).foregroundColor(.secondary)
                        })
                    }
                    
                }
                
                Section {
                    if viewModel.isSigningIn {
                        HStack {
                            Text("Signing In..")
                            Spacer()
                            ProgressView()
                        }
                    } else {
                        Button("Sign In") {
                            viewModel.attemptSignIn()
                        }
                    }
                }
            }
            .alert(isPresented: shouldShowAlert, content: {
                Alert(title: Text("Can't sign in"), message: Text("Please check your credentials and try again"), dismissButton: nil)
            })
            
            NavigationLink(
                destination: IssuesView(viewModel: viewModel.issuesViewModel()).navigationBarBackButtonHidden(true),
                isActive: $viewModel.authenticationSuccessful,
                label: {
                    EmptyView()
                })
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var viewModel = SignInViewModel(provider: MockedProvider())
    static var previews: some View {
        SignInView(viewModel: viewModel)
    }
}
