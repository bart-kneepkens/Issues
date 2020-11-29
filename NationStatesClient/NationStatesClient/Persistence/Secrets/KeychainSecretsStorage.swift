//
//  KeychainSecretsStorage.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/11/2020.
//

import Foundation

class KeychainSecretsStorage: SecureStorage {
    let keychainGroup = "GY3SL5N58H.bart-kneepkens.issues"
    var fetchStatus: OSStatus?
    
    func store(_ value: String?, key: String) {
        guard let value = value else {
            return
        }
        
        guard let valueData = value.data(using: .utf8), let keyData = key.data(using: .utf8) else { return }
        
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrSynchronizable as String: true,
            kSecAttrAccount as String: keyData,
            kSecValueData as String: valueData,
            kSecAttrAccessGroup as String: keychainGroup,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
        ]
        
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        print("Stored \(key) in keychain group with status \(status)")
        
        if status == errSecDuplicateItem {
            
            let updateQuery: [String:Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrSynchronizable as String: true,
                kSecAttrAccount as String: keyData,
                kSecAttrAccessGroup as String: keychainGroup,
                kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
            ]
            
            let newAttributes: [String: Any] = [
                kSecAttrAccount as String: keyData,
                kSecValueData as String: valueData
            ]
            
            let updateStatus: OSStatus = SecItemUpdate(updateQuery as CFDictionary, newAttributes as CFDictionary)
            
            print("Updated \(key) in keychain group with status \(updateStatus)")
        }
    }
    
    func remove(_ key: String) {
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrSynchronizable as String: true,
            kSecAttrAccount as String: key.data(using: .utf8)!,
            kSecAttrAccessGroup as String: keychainGroup,
        ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        print("Removed \(key) from keychain group with status \(status)")
    }
    
    func retrieve(key: String) -> String? {
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrSynchronizable as String: true,
            kSecAttrAccount as String: key.data(using: .utf8)!,
            kSecReturnData as String: true,
            kSecAttrAccessGroup as String: keychainGroup,
        ]
        
        var result: AnyObject?
        let status: OSStatus = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        print("Retrieved \(key) from keychain group with status \(status)")
        
        self.fetchStatus = status
        
        // TODO: add some graceful error handling
        guard let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
}
