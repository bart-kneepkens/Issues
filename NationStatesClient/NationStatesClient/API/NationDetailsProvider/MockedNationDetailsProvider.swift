//
//  MockedNationDetailsProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 24/11/2020.
//

import Foundation
import Combine

#if DEBUG
class MockedNationDetailsProvider: NationDetailsProvider {
    var nationDetails: CurrentValueSubject<Nation?, Never> = .init(nil)
    
    func fetchCurrentNationDetails() async {
        self.nationDetails.send(.filler)
    }
    
    func fetchNationDetails(for nationName: String) async throws -> Nation? {
        .filler
    }
    
}
#endif
