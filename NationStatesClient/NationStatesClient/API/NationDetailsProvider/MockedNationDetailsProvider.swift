//
//  MockedNationDetailsProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 24/11/2020.
//

import Foundation

class MockedNationDetailsProvider: NationDetailsProvider {
    var nationDetails: Nation?
    
    func fetchDetails() {
        self.nationDetails = .filler
    }
}
