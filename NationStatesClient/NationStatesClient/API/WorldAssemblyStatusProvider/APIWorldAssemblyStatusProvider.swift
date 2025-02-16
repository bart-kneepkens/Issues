//
//  APIWorldAssemblyStatusProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 16/02/2025.
//

import Foundation

final class APIWorldAssemblyStatusProvider: WorldAssemblyStatusProvider {
    var status: String? {
        get async {
            await api.worldAssemblyStatus
        }
    }
    
    private let api = ExperimentsAPI()
}
