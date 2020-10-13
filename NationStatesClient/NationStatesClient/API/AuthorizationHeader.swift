//
//  AuthenticationMode.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 13/10/2020.
//

import Foundation

extension AuthenticationMode {
    var header: String {
        switch self {
        case .password(_): return "X-Password"
        case .autologin(_): return "X-Autologin"
        case .pin(_): return "X-Pin"
        }
    }
}
