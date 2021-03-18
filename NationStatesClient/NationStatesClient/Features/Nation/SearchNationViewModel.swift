//
//  SearchNationViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 17/02/2021.
//

import Foundation
import Combine

class SearchNationViewModel: ObservableObject {
    @Published var state: FetchedNationViewModel.State = .initial
    @Published var searchTerm = CurrentValueSubject<String, Never>("")
    private let nationDetailsProvider: NationDetailsProvider
    
    private var cancellables: [AnyCancellable] = []
    
    init(nationDetailsProvider: NationDetailsProvider) {
        self.nationDetailsProvider = nationDetailsProvider
        
        searchTerm.debounce(for: .seconds(1), scheduler: RunLoop.main).sink(receiveValue: { searchQuery in
            guard !searchQuery.isEmpty else {
                if self.state != .initial {
                    self.state = .initial
                }
                return
            }
            
            self.state = .loading(searchQuery)
            
            nationDetailsProvider
                .fetchNationDetails(for: searchQuery)
                .receive(on: DispatchQueue.main)
                .catch({ apiError -> AnyPublisher<Nation?, Never> in
                    self.state = .error(apiError)
                    return Just(nil).eraseToAnyPublisher()
                })
                .sink(receiveValue: { output in
                    if let nation = output {
                        self.state = .loaded(nation)
                    }
                })
                .store(in: &self.cancellables)
        })
        .store(in: &cancellables)
    }
}
