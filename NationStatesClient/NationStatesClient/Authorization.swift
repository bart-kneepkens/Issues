//
//  Authorization.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/10/2020.
//

import Foundation

enum AuthorizationMode {
    case pin
    case autologin
    case password
}

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
    
    var autoLoginKey: String? {
        didSet {
            self.storage.store(autoLoginKey, key: StorageKey.autoLoginKey)
        }
    }
    
    var pin: String? {
        didSet {
            self.storage.store(autoLoginKey, key: StorageKey.pin)
        }
    }
}

extension Authorization {
    struct StorageKey {
        static let nationName = "nationName"
        static let password = "password"
        static let autoLoginKey = "autoLoginKey"
        static let pin = "pin"
    }
}
