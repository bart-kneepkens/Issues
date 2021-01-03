//
//  WorldAssembly.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 03/01/2021.
//

import Foundation

enum WorldAssembly {
    case general
    case security
}

extension WorldAssembly {
    var councilId: String {
        switch self {
        case .general: return "1"
        case .security: return "2"
        }
    }
    
    var textDescription: String {
        switch self {
        case .general: return "General Assembly"
        case .security: return "Security Council"
        }
    }
    
    var iconName: String {
        switch self {
        case .general: return "scalemass"
        case .security: return "shield"
        }
    }
}
