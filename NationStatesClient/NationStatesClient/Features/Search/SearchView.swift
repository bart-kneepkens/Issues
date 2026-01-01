//
//  SearchView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 01/01/2026.
//

import SwiftUI
import UIKit

struct SearchView: View {
    
    enum SearchType {
        case nation
        case region
    }
    
    enum SearchState {
        case initial
        case loading(SearchType)
        case showingNation(Nation)
        case showingRegion(Region)
        case error(APIError)
    }
    
    let regionProvider: RegionDetailsProvider
    let nationProvider: NationDetailsProvider
    
    @State var type: SearchType = .nation
    @FocusState var isSearchFocused: Bool
    
    @StateObject
    fileprivate var debouncer: SearchQueryDebouncer = .init()
    
    @State var searchState: SearchState = .initial
    
    @State
    var fetchedRegion: Region?
    @State
    var fetchedNation: Nation?
    
    
    @State
    var loading = false
    @State
    var error: APIError?
    
    var body: some View {
        VStack {
            if isSearchFocused {
                Picker("", selection: $type) {
                    Text("Nation").tag(SearchType.nation)
                    Text("Region").tag(SearchType.region)
                }
                .pickerStyle(.palette)
                .padding()
            }
            Spacer()
            switch searchState {
            case .initial:
                Text("Search away..")
            case .loading:
                ProgressView()
            case .showingNation(let nation):
                List {
                    NationDetailsView(nation: nation)
                        .onTapGesture {
                            self.hideKeyboard()
                        }
                }
            case .showingRegion(let region):
                List {
                    RegionDetailsView(region: region)
                        .onTapGesture {
                            self.hideKeyboard()
                        }
                }
            case .error(let error):
                ErrorView(error: error, onPress: nil)
            }
            
            Spacer()
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $debouncer.query)
        .searchFocused($isSearchFocused)
        .disableAutocorrection(true)
        .onAppear {
            isSearchFocused.toggle()
        }
        .onChange(of: debouncer.debouncedQuery) {
            if debouncer.debouncedQuery == "" {
                searchState = .initial
                return
            }
            Task {
                if type == .nation {
                    await searchForNation(query: debouncer.debouncedQuery)
                } else {
                    await searchForRegion(query: debouncer.debouncedQuery)
                }
            }
        }
    }
    
    private func searchForNation(query: String) async {
        searchState = .loading(.nation)
        if let nation = try? await nationProvider.fetchNationDetails(for: debouncer.debouncedQuery) {
            self.fetchedNation = nation
            searchState = .showingNation(nation)
        } else {
            self.error = .nationNotFound
            searchState = .error(.nationNotFound)
        }
    }
    
    private func searchForRegion(query: String) async {
        searchState = .loading(.region)
        if let region = await regionProvider.fetchRegionDetails(with: debouncer.debouncedQuery) {
            self.fetchedRegion = region
            searchState = .showingRegion(region)
        } else {
            self.error = .regionNotFound
            searchState = .error(.regionNotFound)
        }
    }
}

#if DEBUG
#Preview {
    SearchView(regionProvider: MockedRegionDetailsProvider(), nationProvider: MockedNationDetailsProvider())
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

