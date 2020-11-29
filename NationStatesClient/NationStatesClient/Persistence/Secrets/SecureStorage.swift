//
//  SecureStorage.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/10/2020.
//

import Foundation

protocol SecureStorage {
    func store(_ value: String?, key: String)
    func retrieve(key: String) -> String?
    func remove(_ key: String)
}
