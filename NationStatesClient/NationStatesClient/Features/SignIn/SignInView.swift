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
    @State var shouldShowSingupSheet = false
    
    var shouldShowAlert: Binding<Bool> {
        .init(get: { self.viewModel.signInError != nil }, set: {_ in})
    }
    
    var body: some View {
        ZStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        VStack {
                            Image("Icon").resizable().frame(width: 128, height: 128, alignment: .center)
                                .cornerRadius(25)
                            
                            Text("Issues").font(.largeTitle).fontWeight(.bold)
                            Text("for NationStates")
                        }
                        Spacer()
                    }
                }
                
                Section(header: Text("Sign in to your nation")) {
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
                            Image(systemName: self.shouldRevealPassword ? "eye.slash" : "eye")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                                .foregroundColor(.secondary)
                        })
                    }
                    
                }
                
                Section(header: Text("Don't have a nation yet?")) {
                    Button("Create a nation") {
                        self.shouldShowSingupSheet.toggle()
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
                        .disabled(viewModel.signInButtonDisabled)
                    }
                }
            }
            // When signing out, the previous navigationBarItems stay in place
            // Replace them explicitly with Empty views
            .navigationBarItems(leading: EmptyView(), trailing: EmptyView())
            .navigationBarHidden(true)
            .navigationBarTitle("")
            .alert(isPresented: shouldShowAlert, content: {
                Alert(title: Text("Can't sign in"), message: Text("Please check your credentials and try again"), dismissButton: nil)
            })
            .sheet(isPresented: $shouldShowSingupSheet) {
                if let url = URL(string: "https://www.nationstates.net/page=create_nation") {
                    SafariView(url: url)
                }
            }
            
            
            NavigationLink(
                destination: IssuesView(viewModel: viewModel.issuesViewModel()).navigationBarBackButtonHidden(true),
                isActive: $viewModel.authenticationSuccessful,
                label: {
                    EmptyView()
                })
        }
    }
}

#if DEBUG
struct SignInView_Previews: PreviewProvider {
    static var viewModel = SignInViewModel(issueProvider: MockedIssueProvider(), authenticationProvider: MockedAuthenticationProvider(), authenticationContainer: .init())
    static var previews: some View {
        SignInView(viewModel: viewModel)
    }
}
#endif
