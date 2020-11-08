//
//  OptionMO+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/11/2020.
//

import Foundation

extension OptionMO {
    func configure(with option: Option) {
        self.text = option.text
        self.id = Int32(option.id)
    }
    
    var option: Option {
        return Option(id: Int(self.id), text: self.text ?? "")
    }
}
