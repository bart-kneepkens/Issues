//
//  KeychainSecretsStorage.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/11/2020.
//

import Foundation
import KeychainAccess

class KeychainSecretsStorage: SecureStorage {
    private let keychainGroup = "GY3SL5N58H.bart-kneepkens.issues"
    private let keychain: Keychain
    
    init() {
        self.keychain = Keychain(service: "bart-kneepkens.issues", accessGroup: keychainGroup)
            .accessibility(.afterFirstUnlock)
            .synchronizable(true)
    }
    
    func store(_ value: String?, key: String) {
        guard let value = value else {
            return
        }
        
        try? keychain.set(value, key: key)
        
        print("Stored \(key) in keychain group")
    }
    
    func remove(_ key: String) {
        try? keychain.remove(key)
        
        print("Removed \(key) from keychain group")
    }
    
    func retrieve(key: String) -> String? {
        return keychain[key]
    }
    
}
