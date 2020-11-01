//
//  Authentication.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/10/2020.
//

import Foundation
import Combine

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

class AuthenticationContainer: ObservableObject {
    private let storage: SecureStorage
    
    init() {
        self.storage = UserDefaultsStorage()
        if let nationName = storage.retrieve(key: StorageKey.nationName), let autoLogin = storage.retrieve(key: StorageKey.autoLogin), let pin = storage.retrieve(key: StorageKey.pin) {
            self.pair = (nationName: nationName, autologin: autoLogin, pin: pin)
        }
    }
    
    var canPerformSilentLogin: Bool {
        return self.pair != nil
    }
    
    @Published var pair: AuthenticationPair? {
        didSet {
            if let pair = pair {
                self.storage.store(pair.nationName, key: StorageKey.nationName)
                self.storage.store(pair.autologin, key: StorageKey.autoLogin)
                self.storage.store(pair.pin, key: StorageKey.pin)
            } else {
                self.storage.store(nil, key: StorageKey.nationName)
                self.storage.store(nil, key: StorageKey.autoLogin)
                self.storage.store(nil, key: StorageKey.pin)
            }
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
    }
}
