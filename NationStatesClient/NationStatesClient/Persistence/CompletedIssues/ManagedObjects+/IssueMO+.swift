//
//  IssueMO+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/11/2020.
//

import CoreData

extension IssueMO {
    convenience init(with issue: Issue, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.id = Int32(issue.id)
        self.imageName = issue.imageName
        self.title = issue.title
        self.text = issue.text
        
        self.options = NSSet(array: issue.options.map({ OptionMO(with: $0, context: context) }))
    }
    
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
    
    var issue: Issue {
        Issue(self.dto)
    }
}
