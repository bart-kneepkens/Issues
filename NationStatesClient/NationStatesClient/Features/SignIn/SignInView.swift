//
//  SignInView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel: SignInViewModel
    @State var shouldShowSingupSheet = false
    
    private var shouldShowAlert: Binding<Bool> {
        .init(get: { self.viewModel.signInError != nil }, set: {_ in})
    }
    
    private var screenHeader: some View {
        HStack {
            Spacer()
            VStack {
                Image("Icon")
                    .resizable()
                    .frame(width: 128, height: 128, alignment: .center)
                    .cornerRadius(25)
                
                Text("Issues")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("for NationStates")
            }
            Spacer()
        }
    }
    
    private var createNationFooter: some View {
        HStack {
            Text("Don't have a nation yet?").textCase(.none)
            Button(action: {
                self.shouldShowSingupSheet.toggle()
            }) {
                Text("Create one").foregroundColor(.accentColor).textCase(.none)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Form {
                Section {
                   screenHeader
                }
                
                Section(header: Text("Sign in to your nation").textCase(.none)) {
                    TextField("Nation name", text: $viewModel.nationName).disableAutocorrection(true)
                    ToggleablePasswordField(text: $viewModel.password)
                }
                
                Section(footer: createNationFooter) {
                    if viewModel.isSigningIn {
                        HStack {
                            Text("Signing In..")
                            Spacer()
                            ProgressView()
                        }
                    } else {
                        Button(action: {
                            viewModel.attemptSignIn()
                        }) {
                            Text("Sign in").fontWeight(.medium)
                        }.disabled(viewModel.signInButtonDisabled)
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
                CreateNationSheet() { result in
                    self.shouldShowSingupSheet = false
                    
                    if let result = result {
                        viewModel.nationName = result.nationName
                        viewModel.password = result.password
                    }
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
    static var viewModel = SignInViewModel(issueProvider: MockedIssueProvider(), authenticationProvider: MockedAuthenticationProvider(success: true), authenticationContainer: .init())
    static var previews: some View {
        SignInView(viewModel: viewModel)
    }
}
#endif
