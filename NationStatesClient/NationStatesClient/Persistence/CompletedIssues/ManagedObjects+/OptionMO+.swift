//
//  OptionMO+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/11/2020.
//

import CoreData

extension OptionMO: ModelConfigurable {
    typealias ModelEquivalent = Option
    
    convenience init(with option: Option, context: NSManagedObjectContext) {
        self.init(context: context)
        self.configure(with: option, using: context)
    }
    
    func configure(with model: Option, using context: NSManagedObjectContext) {
        self.text = model.text
        self.id = Int32(model.id)
    }
}

extension OptionMO: DTOConvertible {
    typealias DTOEquivalent = OptionDTO
    
    var dto: OptionDTO {
        OptionDTO(id: Int(self.id), text: self.text)
    }
}
