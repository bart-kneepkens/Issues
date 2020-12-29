//
//  Freedom.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 27/12/2020.
//

import Foundation

struct FreedomDTO: Equatable {
    var score: Double?
    var rank: Int?
    var regionRank: Int?
    var text: String?
}

struct Freedom {
    let score: Double
    let rank: Int?
    let regionRank: Int?
    let text: String
}

extension Freedom: DTOInitializable {
    typealias DTOEquivalent = FreedomDTO
    
    init?(from dto: FreedomDTO) {
        guard let score = dto.score, let text = dto.text else { return nil }
        self.init(score: score, rank: dto.rank, regionRank: dto.regionRank, text: text)
    }
}
