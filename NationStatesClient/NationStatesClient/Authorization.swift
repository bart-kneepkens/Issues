//
//  Authorization.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/10/2020.
//

import Foundation

class Authorization {
    static let shared = Authorization()
    private let storage: SecureStorage
    
    init() {
        self.storage = UserDefaultsStorage()
        self.nationName = storage.retrieve(key: StorageKey.nationName)
    }
    
    var nationName: String? {
        didSet {
            self.storage.store(nationName, key: StorageKey.nationName)
        }
    }
    
    var password: String? {
        didSet {
            self.storage.store(password, key: StorageKey.password)
        }
    }
}

extension Authorization {
    struct StorageKey {
        static let nationName = "nationName"
        static let password = "password"
    }
}
