//
//  IssueMO+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/11/2020.
//

import CoreData

extension IssueMO: ModelConfigurable {
    typealias ModelEquivalent = Issue
    
    func configure(with model: Issue, using context: NSManagedObjectContext) {
        self.id = Int32(model.id)
        self.imageName = model.imageName
        self.title = model.title
        self.text = model.text
        
        self.options = NSSet(array: model.options.map({ OptionMO(with: $0, context: context) }))
    }
    
    convenience init(with issue: Issue, context: NSManagedObjectContext) {
        self.init(context: context)
        self.configure(with: issue, using: context)
    }
}

extension IssueMO: DTOConvertible {
    typealias DTOEquivalent = IssueDTO
    
    var dto: IssueDTO {
        var d = IssueDTO()
        d.id = Int(self.id)
        d.pic1 = self.imageName
        d.title = self.title
        d.text = self.text

        if let options = self.options as? Set<OptionMO> {
            d.options = Array(options).map({ $0.dto })
        }
        
        return d
    }
}
