//
//  ReclassifyMO+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/11/2020.
//

import CoreData

extension ReclassifyMO: ModelConfigurable {
    typealias ModelEquivalent = Reclassify
    
    func configure(with model: Reclassify, using context: NSManagedObjectContext) {
        self.from = model.from
        self.to = model.to
        self.scaleId = Int32(model.scale.id)
    }
    
    convenience init(with reclassify: Reclassify, context: NSManagedObjectContext) {
        self.init(context: context)
        self.configure(with: reclassify, using: context)
    }
}

extension ReclassifyMO: DTOConvertible {
    typealias DTOEquivalent = ReclassifyDTO
    
    var dto: ReclassifyDTO {
        ReclassifyDTO(type: Int(self.scaleId), from: self.from, to: self.to)
    }
}
