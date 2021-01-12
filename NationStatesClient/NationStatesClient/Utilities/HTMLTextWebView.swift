//
//  HTMLTextWebView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 30/12/2020.
//

import UIKit
import SwiftUI
import WebKit
    
struct HTMLTextWebView: UIViewRepresentable {
    
    let html: String
    private var onLinkTapped: ((String) -> Void)? = nil
    
    init(html: String) {
        self.html = html
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: HTMLTextWebView
        
        init(_ parent: HTMLTextWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .linkActivated, let urlString = navigationAction.request.url?.absoluteString, let onLinkTapped = self.parent.onLinkTapped {
                onLinkTapped(urlString)
            }
            decisionHandler(.allow)
        }
    }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> WKWebView {
        let webView = WKWebView()

        webView.isOpaque = false
        webView.scrollView.indicatorStyle = webView.traitCollection.userInterfaceStyle == .light ? UIScrollView.IndicatorStyle.black : .white
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
                        font: -apple-system-body;
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

extension HTMLTextWebView {
    @inlinable public func onLinkTap(perform action: ((String) -> Void)? = nil) -> some View {
        var copy = self
        copy.onLinkTapped = action
        return copy
    }
}


struct HTMLTextWebView_Previews: PreviewProvider {
    static var previews: some View {
        HTMLTextWebView(html: """
            <div class="WA_thing_body"><p>The World Assembly,</p><p><i>Recognising</i> that radio technology is used by many member states for communication,</p><p><i>Lamenting</i> the lack of international standards for radio communication,</p><p><i>Considering</i> the detrimental effects that a lack of standards has on international radio communication, such as incompatibilities in equipment,</p><p><i>Especially worried</i> that a lack of international cooperation could result in non-coordination and even interference in essential radio communications,</p><p><i>Aware</i> that sudden regulatory changes are likely to cause severe confusion in existing radio transmissions,</p><p>Hereby enacts as follows:</p><p></p><ol><li><p><b>International Radiocommunications Authority</b>: There shall be an International Radiocommunications Authority (IRA), which shall be an organ of the WA Scientific Programme.</p></li><li><p><b>Radio spectrum allocations</b>: For each member state using radio for communication, the IRA shall allocate parts of the radio spectrum for each relevant kind of communication in that state, which shall include at least public broadcasting and recreational use. The allocations shall be made considering the existing use in that state and other nearby states, in order to increase compatibility of standards between nations while minimising inconvenience to existing radio transmission. Member states shall be required to comply with these allocations after a reasonable transition period fixed by the IRA. The allocations may be changed from time to time by consultation between the IRA and member states.</p></li><li><p><b>Registry of radio transmitters</b>: Member states shall maintain a registry, revised frequently, of all persons or institutions equipped to transmit radio signals which can be recieved over long distances, and shall allocate frequencies to each of them if necessary to avoid interference of signals. Member states shall submit this registry to the IRA regularly. Member states shall make freely available all portions of the registry for which doing so would not unduly infringe on privacy or national security.</p></li><li><p><b>Restrictions on equipment</b>: </p><ol style="list-style-type:lower-latin"><li><p>Member states may: </p><ol style="list-style-type:lower-roman"><li><p>Prohibit or restrict the manufacture, sale or purchase of equipment capable of transmitting radio signals outside the ranges allocated for public broadcasting and recreational use,</p></li><li><p>Require that equipment capable of transmitting radio signals, other than equipment solely for private communication on frequencies specified for that purpose (such as mobile telephones) only be sold to persons licensed to operate such equipment, provided such licensing is widely available without unreasonable costs or restrictions,</p></li><li><p>Prohibit or restrict the manufacture, sale or purchase of equipment capable of receiving radio signals in any ranges allocated for secret military or security communication, or</p></li><li><p>Prohibit the transmission of radio signals at a power which is likely to injure or kill any sentient beings living in that area, except in a contained environment for scientific research.</p></li></ol><p></p></li><li><p>Member states may not impose unreasonable restrictions on the manufacture, sale or purchase of equipment for transmitting or receiving radio signals which are not covered by article 4a.</p></li></ol><p></p></li></ol><p></p></div>
            """)
    }
}

