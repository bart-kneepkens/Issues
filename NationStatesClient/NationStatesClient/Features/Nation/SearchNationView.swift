//
//  SearchNationView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 16/02/2021.
//

import SwiftUI
import UIKit

struct SearchNationView: View {
    @Environment(\.viewModelFactory) var viewModelFactory: ViewModelFactory
    
    @StateObject var viewModel: SearchNationViewModel
    
    private var searchTermBinding: Binding<String> {
        .init { () -> String in
            viewModel.searchTerm.value
        } set: { newValue in
            viewModel.searchTerm.send(newValue)
        }
    }
    
    private var input: some View {
        SearchBar(searchTerm: searchTermBinding)
    }
    
    @ViewBuilder private var contents: some View {
        switch viewModel.state {
        case .initial:
            EmptyView()
        case .loaded(let nation):
            NationDetailsView(nation: nation)
        case .error(let apiError):
            ErrorView(error: apiError, onPress: nil)
        default:
            ProgressView()
        }
    }
    
    var body: some View {
        List {
            Section(header: input) {
                contents
                    .onTapGesture {
                        self.hideKeyboard()
                    }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
struct SearchNationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchNationView(viewModel: .init(nationDetailsProvider: MockedNationDetailsProvider()))
        }
    }
}
#endif
