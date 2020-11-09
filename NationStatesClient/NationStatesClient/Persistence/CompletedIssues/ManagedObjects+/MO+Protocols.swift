//
//  MO+Protocols.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/11/2020.
//

import CoreData

protocol ModelConfigurable {
    associatedtype ModelEquivalent
    func configure(with model: ModelEquivalent, using context: NSManagedObjectContext)
}

protocol DTOConvertible {
    associatedtype DTOEquivalent
    var dto: DTOEquivalent { get }
}
