//
//  ReclassifyMO+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/11/2020.
//

import CoreData

extension ReclassifyMO {
    convenience init(with reclassify: Reclassify, context: NSManagedObjectContext) {
        self.init(context: context)
        self.from = reclassify.from
        self.to = reclassify.to
        self.scaleId = Int32(reclassify.scale.id)
    }
    
    var dto: ReclassifyDTO {
        ReclassifyDTO(type: Int(self.scaleId), from: self.from, to: self.to)
    }
    
    var reclassify: Reclassify {
        Reclassify(dto: self.dto)
    }
}
