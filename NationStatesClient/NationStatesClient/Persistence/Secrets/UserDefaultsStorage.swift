//
//  UserDefaultsStorage.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/10/2020.
//

import Foundation

// NOT SECURE, TODO: change to secure keychain
class UserDefaultsStorage: SecureStorage {
    func store(_ value: String?, key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    func remove(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func retrieve(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
}
