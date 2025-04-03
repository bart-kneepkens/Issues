//
//  DeeplinkHandler.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 03/04/2025.
//

import Foundation
import Combine

final class DeeplinkHandler: ObservableObject {
    
    @Published
    var activeLink: Link?
    
    func handle(url: URL) {
        self.activeLink = .from(url)
    }
    
    enum Link {
        case issue(Int)
        
        static func from(_ url: URL) -> Link? {
            if url.scheme == "issue" {
                guard let idString = url.host(percentEncoded: false), let issueId = Int(idString) else { return nil }
                return .issue(issueId)
            }
            return nil
        }
    }
}
