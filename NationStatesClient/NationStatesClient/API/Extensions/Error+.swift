//
//  Error+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/01/2021.
//

import Foundation

extension Error {
    var asAPIError: APIError {
        if let apiError = self as? APIError {
            return apiError
        }
        if (self as NSError).code == NSURLErrorNotConnectedToInternet {
            return APIError.notConnected
        }
        if (self as NSError).code == NSURLErrorTimedOut {
            return APIError.timedOut
        }
        return APIError.unknown(code: (self as NSError).code)
    }
}
