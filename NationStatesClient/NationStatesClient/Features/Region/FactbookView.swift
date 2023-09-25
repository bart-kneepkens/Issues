//
//  FactbookView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 25/09/2023.
//

import SwiftUI
import Combine

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
            .sheet(item: $viewModel.selectedLink) { linkType in
                NavigationView {
                    switch linkType {
                    case .nation(name: let nationName):
                        FetchedNationView(viewModel: viewModelFactory.fetchedNationViewModel(nationName))
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle(nationName)
                    case .region(name: let regionName):
                        RegionView(viewModel: viewModelFactory.regionViewModel(regionName))
                    }
                }
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
}

extension FactbookView {
    class FactbookViewModel: ObservableObject {
        @Published var contentHeight: CGFloat = .zero
        @Published var selectedLink: LinkType?
        
        let html: String
        
        init(html: String) {
            self.html = html
        }
        
        func didTapLink(with url: String) {
            selectedLink = LinkType.type(from: url)
        }
    }
}

struct FactbookView_Previews: PreviewProvider {
    static var previews: some View {
        FactbookView(viewModel: .init(html: "<b>cool</b>"))
    }
}
