//
//  Headline.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/11/2020.
//

import Foundation

typealias HeadlineDTO = String?
typealias Headline = String

extension Headline: DTOInitializable {
    typealias DTOEquivalent = HeadlineDTO
    
    init?(from dto: HeadlineDTO) {
        guard let text = dto else { return nil }
        self.init(text)
    }
}
