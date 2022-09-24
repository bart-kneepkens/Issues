//
//  ComposeEmailView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 24/09/2022.
//

import SwiftUI
import MessageUI

struct ComposeEmailView: UIViewControllerRepresentable {
    
    let subject: String?
    let recipients: [String]?
    
    init(subject: String? = nil, recipients: [String]? = nil) {
        self.subject = subject
        self.recipients = recipients
    }
    
    static var canSendEmail: Bool {
        MFMailComposeViewController.canSendMail()
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ComposeEmailView>) -> MFMailComposeViewController {
        let emailComposer = MFMailComposeViewController()
        if let subject = subject {
            emailComposer.setSubject(subject)
        }
        if let recipients = recipients {
            emailComposer.setToRecipients(recipients)
        }
        emailComposer.mailComposeDelegate = context.coordinator
        
        return emailComposer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<ComposeEmailView>) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: ComposeEmailView
        
        init(_ parent: ComposeEmailView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
}
