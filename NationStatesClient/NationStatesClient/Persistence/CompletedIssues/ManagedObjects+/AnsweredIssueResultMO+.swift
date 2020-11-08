//
//  AnsweredIssueResultMO+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/11/2020.
//

import CoreData

extension AnsweredIssueResultMO {
    convenience init(with answeredIssueResult: AnsweredIssueResult, context: NSManagedObjectContext) {
        self.init(context: context)
        self.resultText = answeredIssueResult.resultText
        self.headlines = NSSet(array: answeredIssueResult.headlines.map({ HeadlineMO(with: $0, context: context )}))
        self.reclassifications = NSSet(array: answeredIssueResult.reclassifications.map({ ReclassifyMO(with: $0, context: context) }))
        self.rankings = NSSet(array: answeredIssueResult.rankings.map({ RankingMO(with: $0, context: context) }))
    }
    
    var dto: AnsweredIssueResultDTO {
        var d = AnsweredIssueResultDTO()
        if let headlines = self.headlines as? Set<HeadlineMO> {
            d.headlines = Array(headlines.map({ $0.headline }))
        }
        d.resultText = self.resultText
        
        if let reclassifications = self.reclassifications as? Set<ReclassifyMO> {
            d.reclassifications = reclassifications.map({ $0.dto })
        }
        
        if let rankings = self.rankings as? Set<RankingMO> {
            d.rankings = rankings.map({ $0.dto })
        }
        
        return d
    }
    
    var answeredIssueResult: AnsweredIssueResult {
        AnsweredIssueResult(dto: self.dto)
    }
}
