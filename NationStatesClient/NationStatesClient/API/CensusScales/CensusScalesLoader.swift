//
//  CensusScalesLoader.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 25/10/2020.
//

import Foundation

class CensusScalesLoader {
    let scales: [CensusScale]
    
    init() {
        guard let url = Bundle.main.url(forResource: "CensusScales", withExtension: "plist") else { fatalError() }
        guard let rootDictionary = NSDictionary(contentsOf: url) else { fatalError() }
        guard let scalesData = rootDictionary.value(forKey: "scales") as? [String] else { fatalError() }
        self.scales = scalesData.enumerated().map({ enumerator -> CensusScale in
            return CensusScale(enumerator.element, id: enumerator.offset)
        })
    }
}
