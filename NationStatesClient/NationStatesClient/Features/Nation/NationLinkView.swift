//
//  NationLinkView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 24/09/2023.
//

import SwiftUI
import Combine

struct NationLinkView: View {
    
    @StateObject
    var viewModel: ViewModel
    
    var body: some View {
        switch viewModel.state {
        case .initial(let nationName):
            Text(nationName)
                .fontWeight(.medium)
        case .loaded(let nation):
            Text(nation.name)
                .fontWeight(.medium)
                .foregroundColor(.accentColor)
                .background(nationNavigationLink)
        }
    }
    
    @ViewBuilder
    private var nationNavigationLink: some View {
        if case .loaded(let nation) = viewModel.state {
            NavigationLink {
                List {
                    NationDetailsView(nation: nation)
                }
                .listStyle(.insetGrouped)
            } label: {
                EmptyView()
            }
            .opacity(0)
            
        }
    }
}

struct NationLinkView_Previews: PreviewProvider {
    static var previews: some View {
        NationLinkView(viewModel: .init(nationName: "Elest Adra", nationDetailsProvider: MockedNationDetailsProvider()))
    }
}

extension NationLinkView {
    final class ViewModel: ObservableObject {
        
        enum State {
            case initial(String)
            case loaded(Nation)
        }
        
        @Published
        var state: State
        
        init(nationName: String, nationDetailsProvider: NationDetailsProvider) {
            self.state = .initial(nationName)
            Task {
                if let nation = try? await nationDetailsProvider.fetchNationDetails(for: nationName) {
                    await updateNation(nation: nation)
                }
            }
        }
        
        @MainActor
        private func updateNation(nation: Nation) {
            state = .loaded(nation)
        }
    }
}
