//
//  IdentifiableURL.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 24/09/2022.
//

import Foundation

/// A simpel wrapper class to conform a given URL (value type) to the Identifiable protocol.
class IdentifiableURL: Identifiable {
    let value: URL
    
    init(_ url: URL) {
        self.value = url
    }
    
    init?(string: String) {
        if let url = URL(string: string) {
            self.value = url
        } else {
            return nil
        }
    }
}
