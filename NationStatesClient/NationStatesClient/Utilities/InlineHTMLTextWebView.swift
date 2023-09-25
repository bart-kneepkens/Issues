//
//  InlineHTMLTextWebView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 17/09/2023.
//

import UIKit
import SwiftUI
import WebKit
    
struct InlineHTMLTextWebView: UIViewRepresentable {
    
    @Binding var dynamicHeight: CGFloat
    
    private let html: String
    private var onLinkTapped: ((String) -> Void)? = nil
    
    init(html: String, dynamicHeight: Binding<CGFloat>) {
        self.html = html
        _dynamicHeight = dynamicHeight
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: InlineHTMLTextWebView
        
        init(_ parent: InlineHTMLTextWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .linkActivated,
                let urlString = navigationAction.request.url?.absoluteString,
                let onLinkTapped = self.parent.onLinkTapped {
                onLinkTapped(urlString)
            }
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                if let floatValue = height as? CGFloat {
                    DispatchQueue.main.async {
                        self.parent.dynamicHeight = floatValue
                    }
                }
            })
        }
    }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> WKWebView {
        let webView = WKWebView()

        webView.isOpaque = false
        webView.scrollView.isScrollEnabled = false
        webView.navigationDelegate = context.coordinator
        
        // Used to make the text readable (in dark mode too), imitates the cells in a GroupedInsetList's cells when presented as a sheet (see IssueDetailOptionsView)
        // Sets the proper viewport, font, and text color for links.
        let htmlHeader = """
                <head>
                 <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
                <style type="text/css">
                    * {
                        -webkit-touch-callout: none;
                        -webkit-user-select: none;
                        color-scheme: light dark;
                        font-family: -apple-system;
                    }

                    a {
                        color: #008000;
                    }
                </style>
            </head>
         """
        
        webView.loadHTMLString(htmlHeader + self.html, baseURL: nil)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}
}

extension InlineHTMLTextWebView {
    @inlinable public func onLinkTap(perform action: ((String) -> Void)? = nil) -> some View {
        var copy = self
        copy.onLinkTapped = action
        return copy
    }
}


struct InlineHTMLTextWebView_Previews: PreviewProvider {
    static var CDATA_string = """
[b][color=#cf0007]This region has been [i]conquered[/i] by [/color] [u][url=https://www.nationstates.net/region=the_eternal_order][color=#EEBC1D]The Eternal Order[/color][/url][/u] [color=#cf0007]- The bringers of peace and war[/color][/b]
[quote=the_high_council;46511086]We aim to establish a new world order across NationStates one region at a time. [url=https://www.nationstates.net/page=dispatch/id=1650466]Reach enlightenment[/url] and join us, The Eternal War is almost at hand...[/quote][hr][i]Previously governed by a council of superiors, this region was surrounded and conquered by overwhelming force. Borders now sealed from the outside world, it now stands against a much more threatening foe:

the slow decay of time itself.[/i][hr][b]| [color=#cf0007]Eternal Knights[/color] |[/b] &amp;#9812; [b][nation]King Nephmir II[/nation],[/b] &amp;#9814; [b][nation]United villages of eisbutch[/nation],[/b] &amp;#9816; [b][nation]Improper Classifications[/nation],[/b] &amp;#9816; [b][nation]Fletania[/nation],[/b] &amp;#9816; [b][nation]Gravie[/nation],[/b] &amp;#9816; [b][nation]Scott Ards[/nation][/b],&amp;#9816; [b][nation]Long Eat on[/nation][/b][hr]
"""
    
    static var converted = BBCodeConverter(bbCodeRawText: CDATA_string).htmlText
    
    static var previews: some View {
        InlineHTMLTextWebView(html: converted, dynamicHeight: .constant(400))
    }
}

