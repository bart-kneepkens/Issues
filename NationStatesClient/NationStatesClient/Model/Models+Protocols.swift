//
//  Models+Protocols.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/11/2020.
//

import Foundation

protocol DTOInitializable {
    associatedtype DTOEquivalent
    init?(from dto: DTOEquivalent)
}
