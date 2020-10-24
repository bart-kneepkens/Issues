//
//  CensusScale.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 25/10/2020.
//

import Foundation

struct CensusScale {
    let id: Int
    let name: String
    let unit: String
    let bannerImageName: String
}

extension CensusScale {
    
    /// - Parameter string: a string in format {name}##{unit}##{banner}
    /// - Parameter id: unique identified for this censusscale
    init(_ string: String, id: Int) {
        self.id = id
        let components = string.components(separatedBy: "##")
        self.name = components[0]
        self.unit = components[1]
        self.bannerImageName = components[2]
    }
}
