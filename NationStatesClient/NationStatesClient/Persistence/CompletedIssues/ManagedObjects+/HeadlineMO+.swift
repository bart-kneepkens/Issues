//
//  HeadlineMO+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/11/2020.
//

import CoreData

extension HeadlineMO: ModelConfigurable {
    typealias ModelEquivalent = Headline
    
    convenience init(with headline: Headline, context: NSManagedObjectContext) {
        self.init(context: context)
        self.configure(with: headline, using: context)
    }
    
    func configure(with model: Headline, using context: NSManagedObjectContext) {
        self.text = model
    }
}

extension HeadlineMO: DTOConvertible {
    typealias DTOEquivalent = HeadlineDTO
    
    var dto: HeadlineDTO {
        self.text
    }
}
