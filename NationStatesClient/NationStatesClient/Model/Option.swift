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

struct OptionDTO {
    var id: Int?
    var text: String?
}

extension OptionDTO: Decodable, Equatable {}

extension Option: DTOInitializable {
    typealias DTOEquivalent = OptionDTO
    
    init?(from dto: OptionDTO) {
        guard let id = dto.id, let text = dto.text else { return nil }
        self.init(id: id, text: text)
    }
}
