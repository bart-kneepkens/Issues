//
//  AnsweredIssueResult.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 25/10/2020.
//

import Foundation

struct RankingDTO {
    var id: Int?
    var score: Float?
    var change: Float?
    var percentualChange: Float?
}

struct Ranking: Equatable, Hashable {
    let scale: CensusScale
    let score: Float
    let change: Float
    let percentualChange: Float
    
    init(dto: RankingDTO) {
        self.scale = CensusScalesLoader.shared.scale(for: dto.id ?? -1) ?? .unknown
        self.score = dto.score ?? 0
        self.change = dto.change ?? 0
        self.percentualChange = dto.percentualChange ?? 0
    }
}

struct ReclassifyDTO {
    var type: Int?
    var from: String?
    var to: String?
}

struct Reclassify: Equatable, Hashable {
    let scale: CensusScale
    let from: String
    let to: String
    
    init(dto: ReclassifyDTO) {
        self.scale = CensusScalesLoader.shared.scale(for: dto.type ?? -1) ?? .unknown
        self.from = dto.from ?? ""
        self.to = dto.to ?? ""
    }
}

typealias Headline = String

struct AnsweredIssueResultDTO {
    var resultText: String?
    var headlines: [Headline] = []
    var reclassifications: [ReclassifyDTO] = []
    var rankings: [RankingDTO] = []
}

struct AnsweredIssueResult {
    let resultText: String
    let headlines: [Headline]
    let reclassifications: [Reclassify]
    let rankings: [Ranking]
    
    init(dto: AnsweredIssueResultDTO) {
        self.resultText = dto.resultText ?? ""
        self.headlines = dto.headlines
        self.reclassifications = dto.reclassifications.map({ Reclassify(dto: $0 )})
        self.rankings = dto.rankings.map({ Ranking(dto: $0)})
    }
}
