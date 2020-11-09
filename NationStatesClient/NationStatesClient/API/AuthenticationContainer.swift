//
//  Authentication.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/10/2020.
//

import Foundation
import Combine

// TODO: maybe convert this to a struct, so APIRequest can return an updated container instead of changing an existing one
class AuthenticationContainer: ObservableObject {
    private let storage: SecureStorage
    
    init(storage: SecureStorage = KeychainSecretsStorage()) {
        self.storage = storage
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
            if let pair = pair, let autologin = pair.autologin, let pin = pair.pin {
                self.storage.store(autologin, key: StorageKey.autoLogin)
                self.storage.store(pin, key: StorageKey.pin)
            } else if pair == nil {
                self.storage.remove(key: StorageKey.autoLogin)
                self.storage.remove(key: StorageKey.pin)
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
