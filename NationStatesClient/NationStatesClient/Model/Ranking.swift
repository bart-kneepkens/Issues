//
//  Ranking.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/11/2020.
//

import Foundation

struct RankingDTO: Equatable, Hashable {
    var id: Int?
    var score: Float?
    var change: Float?
    var percentualChange: Float?
}

struct Ranking: Hashable {
    let scale: CensusScale
    let score: Float
    let change: Float
    let percentualChange: Float
}

extension Ranking: DTOInitializable {
    typealias DTOEquivalent = RankingDTO
    
    init?(from dto: RankingDTO) {
        guard let scaleId = dto.id, let score = dto.score, let change = dto.change, let percentualChange = dto.percentualChange else { return nil }
        self.init(scale: CensusScalesLoader.shared.scale(for: scaleId) ?? .unknown,
                  score: score,
                  change: change,
                  percentualChange: percentualChange)
    }
}
