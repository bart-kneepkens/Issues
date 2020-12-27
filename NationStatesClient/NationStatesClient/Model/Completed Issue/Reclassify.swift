//
//  Reclassify.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/11/2020.
//

import Foundation

struct ReclassifyDTO: Equatable, Hashable {
    var type: Int?
    var from: String?
    var to: String?
}

struct Reclassify: Hashable {
    let scale: CensusScale
    let from: String
    let to: String
}

extension Reclassify: DTOInitializable {
    typealias DTOEquivalent = ReclassifyDTO
    
    init?(from dto: ReclassifyDTO) {
        guard let scaleId = dto.type, let from = dto.from, let to = dto.to else { return nil }
        self.init(scale: CensusScalesLoader.shared.scale(for: scaleId) ?? .unknown,
                  from: from,
                  to: to)
    }
}
