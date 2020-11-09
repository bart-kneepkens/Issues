//
//  KeychainSecretsStorage.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/11/2020.
//

import Foundation

class KeychainSecretsStorage: SecureStorage {
    func store(_ value: String, key: String) {
        
        guard let valueData = value.data(using: .utf8), let keyData = key.data(using: .utf8) else { return }
        
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrSynchronizable as String: true,
            kSecAttrAccount as String: keyData,
            kSecValueData as String: valueData,
        ]
        
        let _: OSStatus = SecItemAdd(query as CFDictionary, nil)
    }
    
    func remove(key: String) {
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrSynchronizable as String: true,
            kSecAttrAccount as String: key.data(using: .utf8)!,
        ]
        
        let _: OSStatus = SecItemDelete(query as CFDictionary)
    }
    
    func retrieve(key: String) -> String? {
        
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrSynchronizable as String: true,
            kSecAttrAccount as String: key.data(using: .utf8)!,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status: OSStatus = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard let data = result as? Data else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
    
    
}
