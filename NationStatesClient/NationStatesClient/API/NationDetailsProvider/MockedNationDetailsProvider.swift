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
    var nationDetails = CurrentValueSubject<Nation?,Never>(nil)
    
    func fetchCurrentNationDetails() {
        self.nationDetails.send(.filler)
    }
}
#endif
