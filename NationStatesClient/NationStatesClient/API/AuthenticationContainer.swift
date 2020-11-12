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
    
    init(storage: SecureStorage = UserDefaultsStorage()) {
        self.storage = storage
        self.autologin = storage.retrieve(key: StorageKey.autoLogin)
        self.pin = storage.retrieve(key: StorageKey.pin)
        self.nationName = storage.retrieve(key: StorageKey.nationName) ?? ""
        self.password = storage.retrieve(key: StorageKey.password) ?? ""
    }
    
    var canPerformSilentLogin: Bool {
        return !self.nationName.isEmpty && !self.password.isEmpty
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
    
    var autologin: String? {
        didSet {
            self.storage.store(autologin, key: StorageKey.autoLogin)
        }
    }
    
    var pin: String? {
        didSet {
            self.storage.store(pin, key: StorageKey.pin)
        }
    }
    
    @Published var hasSignedOut: Bool = false

    func signOut() {
        self.nationName = ""
        self.password = ""
        self.autologin = nil
        self.pin = nil
        self.hasSignedOut = true
        self.objectWillChange.send()
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
