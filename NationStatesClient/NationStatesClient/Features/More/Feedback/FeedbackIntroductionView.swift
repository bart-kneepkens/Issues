//
//  FeedbackIntroductionView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 26/05/2022.
//

import SwiftUI
import MessageUI

struct FeedbackIntroductionView: View {
    
    @State var showingComposeEmailView = false
    @State var showingURL: IdentifiableURL? = nil
    
    var body: some View {
        List {
            Section {
                Text("Hey there! Bart here, the developer of this app.\n\nIssues for NationStates contains no tracking and no analytics. This means that I have no data on how you use the app, which is great for privacy, but it also means that I can't know about problems you face, or features that could be useful for you.\n\nIt would be a huge help if you could share some of your feedback with me, that way I can continue to develop the application and improve your experience.")
            }
            .sheet(item: $showingURL) { url in
                SafariView(url: url.value)
            }
            
            if ComposeEmailView.canSendEmail {
                Button {
                    showingComposeEmailView = true
                } label: {
                    Label("Email", systemImage: "envelope")
                }
                .sheet(isPresented: $showingComposeEmailView) {
                    ComposeEmailView()
                }
            }
            
            Button {
                showingURL = IdentifiableURL(string: "http://www.google.com")
            } label: {
                Label("Github Repository", systemImage: "network")
            }
            
            
            Button {
                showingURL = IdentifiableURL(string: "http://www.apple.com")
            } label: {
                Label("NationStates Forum Thread", systemImage: "note.text")
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
