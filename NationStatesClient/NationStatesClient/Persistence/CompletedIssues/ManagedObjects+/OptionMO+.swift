//
//  OptionMO+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/11/2020.
//

import Foundation
import CoreData

extension OptionMO {
    convenience init(with option: Option, context: NSManagedObjectContext) {
        self.init(context: context)
        self.text = option.text
        self.id = Int32(option.id)
    }
    
    var dto: OptionDTO {
        OptionDTO(id: Int(self.id), text: self.text)
    }
    
//    var option: Option {
//        return Option(id: Int(self.id), text: self.text ?? "")
//    }
}
