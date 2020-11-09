//
//  AnsweredIssueResult.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 25/10/2020.
//

import Foundation

struct AnsweredIssueResultDTO {
    var resultText: String?
    var headlines: [HeadlineDTO] = []
    var reclassifications: [ReclassifyDTO] = []
    var rankings: [RankingDTO] = []
}

struct AnsweredIssueResult {
    let resultText: String
    let headlines: [Headline]
    let reclassifications: [Reclassify]
    let rankings: [Ranking]
}

extension AnsweredIssueResult: DTOInitializable {
    typealias DTOEquivalent = AnsweredIssueResultDTO
    
    init?(from dto: AnsweredIssueResultDTO) {
        guard let resultText = dto.resultText else { return nil }
        self.init(resultText: resultText,
                  headlines: dto.headlines.compactMap({ $0 }),
                  reclassifications: dto.reclassifications.compactMap({ Reclassify(from: $0 )}),
                  rankings: dto.rankings.compactMap({ Ranking(from: $0)}))
    }
}



#if DEBUG
extension AnsweredIssueResult {
    static var filler: AnsweredIssueResult = AnsweredIssueResult(from: .init(resultText: "This is the result", headlines: ["Headlines", "Is a song by drake"], reclassifications: [], rankings: []))!
}
#endif
