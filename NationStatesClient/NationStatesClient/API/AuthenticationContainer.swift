//
//  Authentication.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/10/2020.
//

import Foundation
import Combine

class AuthenticationContainer: ObservableObject {
    private let storage: SecureStorage
    
    init() {
        self.storage = UserDefaultsStorage()
        if let autoLogin = storage.retrieve(key: StorageKey.autoLogin), let pin = storage.retrieve(key: StorageKey.pin) {
            self.pair = (autologin: autoLogin, pin: pin)
        }
        self.nationName = storage.retrieve(key: StorageKey.nationName) ?? ""
        self.password = storage.retrieve(key: StorageKey.password) ?? ""
    }
    
    var canPerformSilentLogin: Bool {
        return self.pair != nil
    }
    
    @Published var pair: AuthenticationPair? {
        didSet {
            if let pair = pair {
                self.storage.store(pair.autologin, key: StorageKey.autoLogin)
                self.storage.store(pair.pin, key: StorageKey.pin)
            } else {
                self.storage.store(nil, key: StorageKey.autoLogin)
                self.storage.store(nil, key: StorageKey.pin)
            }
        }
    }
    
    var nationName: String {
        didSet {
            self.storage.store(nationName, key: StorageKey.nationName)
        }
    }
    
    var password: String {
        didSet {
            self.storage.store(password, key: StorageKey.password)
        }
    }

    func clear() {
        self.pair = nil
    }
}

extension AuthenticationContainer {
    struct StorageKey {
        static let nationName = "nationName"
        static let autoLogin = "autoLogin"
        static let pin = "pin"
        static let password = "password"
    }
}
