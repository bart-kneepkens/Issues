//
//  RegionDetailsProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 13/09/2023.
//

import Foundation

protocol RegionDetailsProvider {
    func fetchRegionDetails(with regionName: String) async -> Region?
}
