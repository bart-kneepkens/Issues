//
//  MockedWorldAssemblyStatusProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 16/02/2025.
//

import Foundation

final class MockedWorldAssemblyStatusProvider: WorldAssemblyStatusProvider {
    var status: String? {
        get {
            "test status"
        }
    }
}
