//
//  MockedSecureStorage.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 22/12/2020.
//

import Foundation
@testable import NationStatesClient

class MockedSecureStorage: SecureStorage {
    func remove(_ key: String) {
        
    }
    
    func store(_ value: String?, key: String) {
        
    }
    
    func retrieve(key: String) -> String? {
        return ""
    }
}
