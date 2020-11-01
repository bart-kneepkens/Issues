//
//  Option.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 01/11/2020.
//

import Foundation

struct Option: Identifiable {
    let id: Int
    let text: String
    
    static let dismiss = Option(id: -1, text: "")
}

extension Option {
    init(_ dto: OptionDTO) {
        self.id = dto.id ?? 0
        self.text = dto.text ?? ""
    }
}

struct OptionDTO {
    var id: Int?
    var text: String?
}

extension OptionDTO: Decodable, Equatable {}
