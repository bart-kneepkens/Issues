//
//  IssueMO+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/11/2020.
//

import CoreData

extension IssueMO {
    func configure(with issue: Issue, context: NSManagedObjectContext) {
        self.id = Int32(issue.id)
        self.imageName = issue.imageName
        self.title = issue.title
        self.text = issue.text
        
        self.options = NSSet.init(array: issue.options.map({ option -> OptionMO in
            let ent = OptionMO(context: context)
            ent.configure(with: option)
            return ent
        }))
    }
    
    var issue: Issue {
        let options = (self.options as! Set<OptionMO>).map({ $0.option })
        return Issue(id: Int(self.id), title: self.title ?? "", text: self.text ?? "", options: options, imageName: self.imageName ?? "")
    }
}
