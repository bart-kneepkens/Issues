//
//  AnsweredIssueResultMO+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/11/2020.
//

import CoreData

extension AnsweredIssueResultMO: ModelConfigurable {
    typealias ModelEquivalent = AnsweredIssueResult
    
    func configure(with model: AnsweredIssueResult, using context: NSManagedObjectContext) {
        self.resultText = model.resultText
        self.headlines = NSSet(array: model.headlines.map({ HeadlineMO(with: $0, context: context )}))
        self.reclassifications = NSSet(array: model.reclassifications.map({ ReclassifyMO(with: $0, context: context) }))
        self.rankings = NSSet(array: model.rankings.map({ RankingMO(with: $0, context: context) }))
    }
    
    convenience init(with answeredIssueResult: AnsweredIssueResult, context: NSManagedObjectContext) {
        self.init(context: context)
        self.configure(with: answeredIssueResult, using: context)
    }
}

extension AnsweredIssueResultMO: DTOConvertible {
    typealias DTOEquivalent = AnsweredIssueResultDTO
    
    var dto: AnsweredIssueResultDTO {
        var d = AnsweredIssueResultDTO()
        if let headlines = self.headlines as? Set<HeadlineMO> {
            d.headlines = Array(headlines.map({ $0.dto }))
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
}
