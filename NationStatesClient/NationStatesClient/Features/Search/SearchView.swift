//
//  SearchView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 01/01/2026.
//

import SwiftUI
import UIKit

struct SearchView<Result, Content: View>: View {

    enum SearchState {
        case initial
        case loading
        case showing(Result)
        case error(APIError)
    }
    
    let fetch: (String) async throws -> Result
    let content: (Result) -> Content
    
    @FocusState
    var isSearchFocused: Bool
    
    @StateObject
    fileprivate var debouncer: SearchQueryDebouncer = .init()
    
    @State
    var searchState: SearchState = .initial
    
    var body: some View {
        contents
            .background(
                Color(UIColor.systemGroupedBackground)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
            .searchable(text: $debouncer.query)
            .searchFocused($isSearchFocused)
            .disableAutocorrection(true)
            .safeAreaPadding()
            .onAppear {
                isSearchFocused.toggle()
            }
            .onChange(of: debouncer.debouncedQuery) {
                if debouncer.debouncedQuery == "" {
                    searchState = .initial
                    return
                }
                Task {
                    searchState = .loading
                    
                    do {
                        let result = try await fetch(debouncer.debouncedQuery)
                        searchState = .showing(result)
                    } catch let error as APIError {
                        searchState = .error(error)
                    }
                }
            }
    }
    
    private var contents: some View {
        VStack {
            Spacer()
            switch searchState {
            case .initial:
                Text("Search away..")
            case .loading:
                ProgressView()
            case .showing(let result):
                List {
                    content(result)
                        .onTapGesture { hideKeyboard() }
                }
            case .error(let error):
                ErrorView(error: error, onPress: nil)
            }
            
            Spacer()
            
           
        }
    }
}

#if DEBUG
#Preview {
    SearchView<Nation, NationDetailsView> { query in
        try await MockedNationDetailsProvider().fetchNationDetails(for: query)
    } content: { nation in
        NationDetailsView(nation: nation)
    }

}
#endif

fileprivate final class SearchQueryDebouncer: ObservableObject {
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

