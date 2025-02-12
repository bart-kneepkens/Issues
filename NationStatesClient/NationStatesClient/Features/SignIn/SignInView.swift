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
    
    private var shouldShowInvalidCredentialsAlert: Binding<Bool> {
        .init(get: { self.viewModel.signInError != nil && !shouldShowOutageAlert.wrappedValue }, set: {_ in})
    }
    
    private var shouldShowOutageAlert: Binding<Bool> {
        .init {
            guard let signInError = self.viewModel.signInError else { return false }
            if case APIError.nationStatesOutage = signInError.asAPIError {
                return true
            }
            return false
        } set: { _ in }
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
            Text("Don't have a nation yet?")
            Spacer()
            Button(action: {
                self.shouldShowSingupSheet.toggle()
            }) {
                Text("Create one")
                    .foregroundColor(.accentColor)
                    .fontWeight(.medium)
                    .font(.subheadline)
            }
        }
    }
    
    var body: some View {
        VStack {
            screenHeader
            Form {
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
                            HStack {
                                Spacer()
                                Text("Sign in")
                                    .fontWeight(.medium)
                                Spacer()
                            }
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
            .alert(isPresented: shouldShowInvalidCredentialsAlert, content: {
                Alert(title: Text("Can't sign in"), message: Text("Please check your credentials and try again"), dismissButton: nil)
            })
            .alert(isPresented: shouldShowOutageAlert, content: {
                Alert(title: Text("Server outage"), message: Text("NationStates servers are currently experiencing outage. Please hold tight while it's being resolved, and check the website for details."), dismissButton: nil)
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
            
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}

#if DEBUG
struct SignInView_Previews: PreviewProvider {
    static var viewModel = SignInViewModel(authenticationProvider: MockedAuthenticationProvider(success: true), authenticationContainer: .init(), contentViewModel: ContentViewModel(authenticationContainer: AuthenticationContainer(), authenticationProvider: MockedAuthenticationProvider(success: true), nationDetailsProvider: MockedNationDetailsProvider(), resolutionProvider: MockedResolutionProvider()))
    static var previews: some View {
        SignInView(viewModel: viewModel)
    }
}
#endif
