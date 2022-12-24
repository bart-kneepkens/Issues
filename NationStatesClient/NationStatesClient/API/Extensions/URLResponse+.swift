//
//  URLResponse+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 09/01/2021.
//

import Foundation

extension URLResponse {
    func throwHTTPErrors(data: Data?) throws {
        if let httpResponse = self as? HTTPURLResponse {
            if httpResponse.statusCode == 409 {
                throw APIError.conflict
            }
            if httpResponse.statusCode == 403 {
                // TODO: Find out if there is a better way to detect outages.
                if let data, let dataString = String(data: data, encoding: .utf8), dataString.contains("Closed for Christmas") {
                    throw APIError.nationStatesOutage
                }
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
