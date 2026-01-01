//
//  SearchView+ViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 01/01/2026.
//

import Foundation
import Combine

extension SearchView {

    final class ViewModel: ObservableObject {
        @Published var state: FetchedNationViewModel.State = .initial
        @Published var searchTerm: String = ""
        private let nationDetailsProvider: NationDetailsProvider
        
        private var cancellables: [AnyCancellable] = []
        
        init(nationDetailsProvider: NationDetailsProvider) {
            self.nationDetailsProvider = nationDetailsProvider
            
            $searchTerm
                .debounce(for: .seconds(1), scheduler: RunLoop.main)
                .sink(receiveValue: { [weak self] searchQuery in
                guard let self else { return }
                
                guard !searchQuery.isEmpty else {
                    return
                }
                
                self.state = .loading(searchQuery)
                
                Task {
                    do {
                        if let fetchedNation = try await nationDetailsProvider
                            .fetchNationDetails(for: searchQuery) {
                            await MainActor.run {
                                self.state = .loaded(fetchedNation)
                            }
                        }
                    } catch {
                        await MainActor.run {
                            self.state = .error(error.asAPIError)
                        }
                    }
                }
            })
            .store(in: &cancellables)
        }
    }

}
