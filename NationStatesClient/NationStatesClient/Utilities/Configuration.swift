//
//  Configuration.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 25/09/2022.
//

import Foundation

/// Simple configuration struct
/// This can go in favor of proper '12 factor' configurations (see https://12factor.net/config)
/// But should probably go together with some code generation.
struct Configuration {
    static let githubRepositoryURL: String = ""
    static let forumThreadURL: String = ""
    static let emailRecipient: String = ""
}
