//
//  MockedAuthenticationContainer.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 11/09/2023.
//

import Foundation

class MockedAuthenticationContainer: AuthenticationContainer {
    
    init() {
        super.init(storage: MockedSecureStorage())
    }
}

private class MockedSecureStorage: SecureStorage {
    typealias Key = AuthenticationContainer.StorageKey
    
    func store(_ value: String?, key: String) {}
    
    func retrieve(key: String) -> String? {
        switch key {
        case Key.nationName: return "Elest Adra"
        case Key.password: return "qwerty"
        default: return ""
        }
    }
    
    func remove(_ key: String) {}
}
