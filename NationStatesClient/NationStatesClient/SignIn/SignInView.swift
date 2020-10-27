//
//  SignInView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel: SignInViewModel
    @State var canShowPassword = false
    
    var body: some View {
        let shouldShowAlert: Binding<Bool> = Binding(get: {
            return viewModel.signInError != nil
        }, set: { _ in })
        ZStack {
            VStack {
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
                        if self.canShowPassword {
                            TextField("Password", text: $viewModel.password)
                        } else {
                            SecureField("Password", text: $viewModel.password)
                        }
                            Button(action: {
                                self.canShowPassword.toggle()
                            }, label: {
                                Image(systemName: self.canShowPassword ? "eye.slash" : "eye").resizable().aspectRatio(contentMode: .fit).frame(width: 30).foregroundColor(.secondary)
                            })
                        }
                        
                    }
                    Section {
                        if viewModel.signingIn {
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
            }
            NavigationLink(
                destination: IssuesView(viewModel: IssuesViewModel(provider: MockedProvider())).navigationBarBackButtonHidden(true),
                isActive: $viewModel.shouldNavigateForward,
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
