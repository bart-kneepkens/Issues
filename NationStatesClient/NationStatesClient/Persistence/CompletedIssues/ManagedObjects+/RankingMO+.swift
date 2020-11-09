//
//  RankingMO+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/11/2020.
//

import CoreData

extension RankingMO: ModelConfigurable {
    typealias ModelEquivalent = Ranking
    
    func configure(with model: Ranking, using context: NSManagedObjectContext) {
        self.change = model.change
        self.percentualChange = model.percentualChange
        self.scaleId = Int32(model.scale.id)
        self.score = model.score
    }
    
    convenience init(with ranking: Ranking, context: NSManagedObjectContext) {
        self.init(context: context)
        self.configure(with: ranking, using: context)
    }
}

extension RankingMO: DTOConvertible {
    typealias DTOEquivalent = RankingDTO
    
    var dto: RankingDTO {
        RankingDTO(id: Int(self.scaleId), score: self.score, change: self.change, percentualChange: self.percentualChange)
    }
}
