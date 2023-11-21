//
//  SearchNationView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 16/02/2021.
//

import SwiftUI
import UIKit

struct SearchNationView: View {
    
    @StateObject var viewModel: SearchNationViewModel
    
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
            contents
                .onTapGesture {
                    self.hideKeyboard()
                }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $viewModel.searchTerm)
        .disableAutocorrection(true)
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
