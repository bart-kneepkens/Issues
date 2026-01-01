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
    
    let regionProvider: RegionDetailsProvider
    let nationProvider: NationDetailsProvider
    
    @State var type: SearchType = .nation
    @FocusState var isSearchFocused: Bool
    
    @StateObject
    fileprivate var debouncer: SearchQueryDebouncer = .init()
    
    @State
    var fetchedRegion: Region?
    @State
    var fetchedNation: Nation?
    
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
            
            List {
                if type == .nation, let nation = fetchedNation {
                    NationDetailsView(nation: nation)
                        .onTapGesture {
                            self.hideKeyboard()
                        }
                } else if let fetchedRegion {
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
        if let nation = try? await nationProvider.fetchNationDetails(for: debouncer.debouncedQuery) {
            self.fetchedNation = nation
        } else {
            self.error = .nationNotFound
        }
    }
    
    private func searchForRegion(query: String) async {
        if let region = await regionProvider.fetchRegionDetails(with: debouncer.debouncedQuery) {
            self.fetchedRegion = region
        } else {
            self.error = .regionNotFound
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

