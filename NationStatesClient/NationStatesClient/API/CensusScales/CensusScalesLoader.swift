//
//  CensusScalesLoader.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 25/10/2020.
//

import Foundation

class CensusScalesLoader {
    static let shared = CensusScalesLoader()
    
    private var scales: [Int: CensusScale] = [:]
    
    func load() {
        guard let url = Bundle.main.url(forResource: "CensusScales", withExtension: "plist") else { fatalError() }
        guard let rootDictionary = NSDictionary(contentsOf: url) else { fatalError() }
        guard let scalesData = rootDictionary.value(forKey: "scales") as? [String] else { fatalError() }
        scalesData.enumerated().forEach { enumerator in
            self.scales[enumerator.offset] = CensusScale(enumerator.element, id: enumerator.offset)
        }
    }
    
    func scale(for id: Int) -> CensusScale? {
        return scales[id]
    }
}
