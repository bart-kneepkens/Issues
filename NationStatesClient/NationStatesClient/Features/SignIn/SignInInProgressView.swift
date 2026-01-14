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
        let progressIndicator = progressIndicators.randomElement() ?? ("Signing in..", "newspaper")
        
        VStack {
            Spacer()
            
            Image(systemName: progressIndicator.1)
                .symbolEffect(.pulse, options: .repeating.speed(1), isActive: true)
                .font(.largeTitle)
                .padding()
            
            Text(progressIndicator.0)
            
            Spacer()
            
            if let error = error {
                ErrorView(error: error, onPress: nil)
                    .opacity(0.5)
            }
        }
        .padding()
    }
}

private let progressIndicators: [String: String] = [
    "Signing in..": "signature",
    "Dialing in..": "phone",
    "Fetching the news reports..": "newspaper",
    "Tuning in..": "radio",
    "Inspecting the pigeons..": "binoculars",
    "Reading reports..": "chart.line.uptrend.xyaxis",
    "Combining news sources..": "faxmachine",
    "Getting briefed..": "person.line.dotted.person"
]

struct SignInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        SignInProgressView()
    }
}
