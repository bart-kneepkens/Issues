//
//  RankingMO+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/11/2020.
//

import CoreData

extension RankingMO {
    convenience init(with ranking: Ranking, context: NSManagedObjectContext) {
        self.init(context: context)
        self.change = ranking.change
        self.percentualChange = ranking.percentualChange
        self.scaleId = Int32(ranking.scale.id)
        self.score = ranking.score
    }
    
    var dto: RankingDTO {
        RankingDTO(id: Int(self.scaleId), score: self.score, change: self.change, percentualChange: self.percentualChange)
    }
    
    var ranking: Ranking {
        Ranking(dto: self.dto)
    }
}
