//
//  WorldAssemblyStatusProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 16/02/2025.
//

import Foundation

protocol WorldAssemblyStatusProvider {
    var status: String? {
        get async
    }
}
