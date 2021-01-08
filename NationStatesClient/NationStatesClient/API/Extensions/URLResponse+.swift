//
//  URLResponse+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/01/2021.
//

import Foundation

extension URLResponse {
    func throwHTTPErrors() throws {
        if let httpResponse = self as? HTTPURLResponse {
            if httpResponse.statusCode == 409 {
                throw APIError.conflict
            }
            if httpResponse.statusCode == 403 {
                throw APIError.unauthorized
            }
            if httpResponse.statusCode == 404 {
                throw APIError.notFound
            }
            if httpResponse.statusCode == 429 {
                throw APIError.rateExceeded
            }
            if !(200...299).contains(httpResponse.statusCode) {
                throw APIError.unknown(code: httpResponse.statusCode)
            }
        }
    }
}
