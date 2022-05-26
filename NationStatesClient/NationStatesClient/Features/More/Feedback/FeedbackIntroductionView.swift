//
//  FeedbackIntroductionView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 26/05/2022.
//

import SwiftUI
import MessageUI

struct FeedbackIntroductionView: View {
    var body: some View {
        List {
            Section {
            Text("Hey there! Bart here, the developer of this app.\n\nIssues for NationStates contains no tracking and no analytics. This means that I have no data on how you use the app, which is great for privacy, but it also means that I can't know about problems you face, or features that could be useful for you.\n\nIt would be a huge help if you could share some of your feedback with me, that way I can continue to develop the application and improve your experience.")
            }
            
            if MFMailComposeViewController.canSendMail() {
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "envelope")
                        Text("Open the contact form")
                    }
                }
            }
            
            Button {
                
            } label: {
                HStack {
                    Image(systemName: "network")
                    Text("Github Repository")
                }
            }
        }
        .navigationTitle("Share Feedback")
    }
}

struct FeedbackIntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FeedbackIntroductionView()
        }
    }
}
