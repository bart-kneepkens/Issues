//
//  VoteOption.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 03/01/2021.
//

import Foundation
import SwiftUI

enum VoteOption: Int {
    case voteFor
    case voteAgainst
    
}

extension VoteOption: Identifiable {
    var id: Int {
        self.rawValue
    }
    
    var shortDescription: String {
        switch self {
        case .voteFor: return "for"
        case .voteAgainst: return "against"
        }
    }
    
    var httpValue: String {
        switch self {
        case .voteFor: return "Vote For"
        case .voteAgainst: return "Vote Against"
        }
    }
    
    static func fromAPIValue(_ text: String) -> VoteOption?{
        switch text {
        case "AGAINST": return .voteAgainst
        case "FOR": return .voteFor
        default: return nil
        }
    }
    
    var color: Color {
        switch self {
        case .voteFor: return .blue
        case .voteAgainst: return .red
        }
    }
}

