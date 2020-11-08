//
//  AnsweredIssueResultMO+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/11/2020.
//

import CoreData

extension AnsweredIssueResultMO {
    func configure(with result: AnsweredIssueResult, context: NSManagedObjectContext) {
        self.resultText = result.resultText
        self.headlines = NSSet(array: result.headlines.map({ str -> HeadlineMO in
            let entity = HeadlineMO(context: context)
            entity.text = str
            return entity
        }))
        
        self.reclassifications = NSSet(array: result.reclassifications.map({ reclassify -> ReclassifyMO in
            let entity = ReclassifyMO(context: context)
            entity.from = reclassify.from
            entity.to = reclassify.to
            entity.scaleId = Int32(reclassify.scale.id)
            return entity
        }))
        
        self.rankings = NSSet(array: result.rankings.map({ ranking -> RankingMO in
            let entity = RankingMO(context: context)
            entity.change = ranking.change
            entity.percentualChange = ranking.percentualChange
            entity.scaleId = Int32(ranking.scale.id)
            entity.score = ranking.score
            return entity
        }))
    }
}
