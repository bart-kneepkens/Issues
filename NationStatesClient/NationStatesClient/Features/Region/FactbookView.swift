//
//  FactbookView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 25/09/2023.
//

import SwiftUI
import Combine
import UIKit

struct FactbookView: View {
    @Environment(\.viewModelFactory) var viewModelFactory: ViewModelFactory
    
    @StateObject var viewModel: FactbookViewModel
    
    var body: some View {
        InlineHTMLTextWebView(html: viewModel.html, dynamicHeight: $viewModel.contentHeight)
            .onLinkTap { url in
                viewModel.didTapLink(with: url)
            }
            .frame(height: viewModel.contentHeight)
            .listRowInsets(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
            .sheet(item: $viewModel.selectedInternalLink) { linkType in
                NavigationView {
                    switch linkType {
                    case .nation(name: let nationName):
                        FetchedNationView(viewModel: viewModelFactory.fetchedNationViewModel(nationName))
                    case .region(name: let regionName):
                        RegionView(viewModel: viewModelFactory.regionViewModel(regionName))
                    }
                }
            }
            .sheet(item: $viewModel.selectedExternalLink) { externalLink in
                SafariView(url: externalLink.url)
            }
    }
    
    enum LinkType: Hashable, Identifiable {
        case nation(name: String)
        case region(name: String)
        
        var id: Self { self }
        
        static func type(from url: String) -> Self? {
            if url.contains("nation=") {
                let name = url.components(separatedBy: "=")[1]
                return .nation(name: name)
            } else if url.contains("region=") {
                let name = url.components(separatedBy: "=")[1]
                return .region(name: name)
            }
            return nil
        }
    }
    
    struct ExternalLink: Identifiable {
        let url: URL
        
        var id: String { url.absoluteString }
        
        init?(link: String) {
            if link.hasPrefix("nationstates:"),
                let suffix = link.components(separatedBy: "nationstates:").last,
               let externalURL = URL(string: "https://www.nationstates.net/\(suffix)"){
                self.url = externalURL
            } else if link.hasPrefix("external:"),
                      let contents = link.components(separatedBy: "external:").last,
                      let externalURL = URL(string: contents) {
                self.url = externalURL
            } else {
                return nil
            }
        }
    }
}

extension FactbookView {
    
    class FactbookViewModel: ObservableObject {
        @Published var contentHeight: CGFloat = .zero
        @Published var selectedInternalLink: LinkType?
        @Published var selectedExternalLink: ExternalLink?
        
        let html: String
        
        init(html: String) {
            self.html = html
        }
        
        func didTapLink(with url: String) {
            if let selectedLink = LinkType.type(from: url) {
                self.selectedInternalLink = selectedLink
            } else if let externalLink = ExternalLink(link: url) {
                self.selectedExternalLink = externalLink
            }
        }
    }
}

struct FactbookView_Previews: PreviewProvider {
    static var previews: some View {
        FactbookView(viewModel: .init(html: "<b>cool</b>"))
    }
}
