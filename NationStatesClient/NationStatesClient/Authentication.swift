//
//  Authentication.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/10/2020.
//

import Foundation

enum AuthenticationMode {
    case pin
    case autologin
    case password
    
    var header: String {
        switch self {
        case .password: return "X-Password"
        case .autologin: return "X-Autologin"
        case .pin: return "X-Pin"
        }
    }
}

class Authentication {
    static let shared = Authentication()
    private let storage: SecureStorage
    
    init() {
        self.storage = UserDefaultsStorage()
        self.nationName = storage.retrieve(key: StorageKey.nationName)
        self.autoLogin = storage.retrieve(key: StorageKey.autoLogin)
        self.pin = storage.retrieve(key: StorageKey.pin)
    }
    
    var nationName: String? {
        didSet {
            self.storage.store(nationName, key: StorageKey.nationName)
        }
    }
    
    var password: String? // Not to be stored
    
    var autoLogin: String? {
        didSet {
            self.storage.store(autoLogin, key: StorageKey.autoLogin)
        }
    }
    
    var pin: String? {
        didSet {
            self.storage.store(pin, key: StorageKey.pin)
        }
    }
}

extension Authentication {
    struct StorageKey {
        static let nationName = "nationName"
        static let autoLogin = "autoLogin"
        static let pin = "pin"
    }
}
