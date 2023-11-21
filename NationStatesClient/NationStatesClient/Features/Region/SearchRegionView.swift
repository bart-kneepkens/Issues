//
//  SearchRegionView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 21/11/2023.
//

import SwiftUI
import Combine

struct SearchRegionView: View {
    
    let provider: RegionDetailsProvider
    
    @StateObject
    var debouncer: SearchQueryDebouncer = .init()
    
    @State
    var fetchedRegion: Region?
    
    @State
    var error: APIError?
    
    var body: some View {
        List {
            if let fetchedRegion {
                RegionDetailsView(region: fetchedRegion)
                    .onTapGesture {
                        self.hideKeyboard()
                    }
            } else if let error {
                ErrorView(error: error, onPress: nil)
            } else {
                EmptyView()
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $debouncer.query)
        .disableAutocorrection(true)
        .onChange(of: debouncer.debouncedQuery) { debouncedQuery in
            Task {
                if let region = await provider.fetchRegionDetails(with: debouncedQuery) {
                    self.fetchedRegion = region
                } else {
                    self.error = .regionNotFound
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationView {
        SearchRegionView(provider: MockedRegionDetailsProvider())
    }
}
#endif

final class SearchQueryDebouncer: ObservableObject {
    @Published
    var query: String = ""
    
    @Published
    var debouncedQuery: String = ""
    
    init() {
        $query
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .assign(to: &$debouncedQuery)
    }
}
