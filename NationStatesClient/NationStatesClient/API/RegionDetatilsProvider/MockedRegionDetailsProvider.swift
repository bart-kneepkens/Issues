//
//  MockedRegionDetailsProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 14/09/2023.
//

import Foundation

#if DEBUG
class MockedRegionDetailsProvider: RegionDetailsProvider {
    func fetchRegionDetails(with regionName: String) async -> Region? {
        Region.filler
    }
}
#endif
