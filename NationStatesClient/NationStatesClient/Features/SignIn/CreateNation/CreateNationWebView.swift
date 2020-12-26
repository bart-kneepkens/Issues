//
//  CreateNationWebView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 19/12/2020.
//

import SwiftUI
import SafariServices
import WebKit

struct CreateNationWebView : UIViewRepresentable {
    struct CreateNationResult {
        let nationName: String
        let password: String
    }
    
    let onCompletion: ((CreateNationResult) -> Void)
    let onFinishedStyling: (() -> Void)
    
    private let url: URL? = URL(string: "https://www.nationstates.net/page=create_nation")
    private let webView: WKWebView = WKWebView()
    
    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        let parent: CreateNationWebView
        
        init(_ parent: CreateNationWebView) {
            self.parent = parent
        }
        
        private let allowedPaths = ["page=create_nation", "page=create_nation1", "cgi-bin/build_nation.cgi"]
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            guard let urlString = navigationAction.request.url?.absoluteString else {
                decisionHandler(.allow)
                return
            }
            
            guard allowedPaths.contains(where: { urlString.contains($0) }) else {
                // Check if the url indicates that the nation has been created
                // For example: https://www.nationstates.net/nation=nation_name?founded=new
                if urlString.contains("nation=") && urlString.hasSuffix("?founded=new") {
                    let dispatchGroup = DispatchGroup()
                    var nationName: String = ""
                    var password: String = ""
                    
                    // Read the password from the previous screen's form
                    dispatchGroup.enter()
                    webView.evaluateJavaScript("document.getElementsByName('confirm_password')[0].value;") { (passwordHTML, error) in
                        if let passwordString = passwordHTML as? String {
                            password = passwordString
                        }
                        dispatchGroup.leave()
                    }
                    
                    // Read the nation name from the previous screen's form
                    dispatchGroup.enter()
                    webView.evaluateJavaScript("document.getElementById('name').value;") { (name, error) in
                        if let nameString = name as? String {
                            nationName = nameString
                        }
                        dispatchGroup.leave()
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        self.parent.onCompletion(CreateNationResult(nationName: nationName, password: password))
                    }
                }
                
                // Don't allow further navigation
                decisionHandler(.cancel)
                return
            }
        
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            /*
             This snippet makes the link in the banner disfunctional, and removes the footer.
             This is done to prevent users from browsing to the 'shop' part of the NationStates website,
             and to comply with App Store Review guidelines 3.1.1
            */
            webView.evaluateJavaScript("""
                var summaryBar = document.getElementById('summarybar');
                summaryBar.setAttribute('onclick', '{}');
                summaryBar.setAttribute('href', '');

                var footer = document.getElementById('foot');
                footer.parentElement.removeChild(foot);
                """) { (_, _) in
                self.parent.onFinishedStyling()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        webView.allowsLinkPreview = false
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.uiDelegate = context.coordinator
        uiView.navigationDelegate = context.coordinator
        if let url = self.url {
            uiView.load(URLRequest(url: url))
        }
    }
}

#if DEBUG
struct CreateNationWebView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNationWebView { result in
            
        } onFinishedStyling: {
        
        }
    }
}
#endif
