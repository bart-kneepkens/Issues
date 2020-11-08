//
//  HeadlineMO+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/11/2020.
//

import CoreData

extension HeadlineMO {
    convenience init(with headline: Headline, context: NSManagedObjectContext) {
        self.init(context: context)
        self.text = headline
    }

    var headline: Headline {
        return self.text ?? ""
    }
}
