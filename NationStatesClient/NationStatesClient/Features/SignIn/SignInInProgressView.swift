//
//  SignInInProgressView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 16/12/2020.
//

import SwiftUI

struct SignInProgressView: View {
    var error: APIError?
    
    var body: some View {
        VStack {
            Spacer()
            ProgressView("Signing in..")
            Spacer()
            if let error = error {
                ErrorView(error: error, onPress: nil).opacity(0.5)
            }
        }.padding()
    }
}

struct SignInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        SignInProgressView(error: .timedOut)
    }
}
