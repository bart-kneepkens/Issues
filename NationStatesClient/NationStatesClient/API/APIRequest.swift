//
//  APIRequest.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 04/11/2020.
//

import Foundation
import Combine

class APIRequest {
    let url: URL
    let authenticationContainer: AuthenticationContainer
    let session: NetworkSession
    
    init(url: URL, authenticationContainer: AuthenticationContainer, session: NetworkSession = URLSession.shared) {
        self.url = url
        self.authenticationContainer = authenticationContainer
        self.session = session
    }
    
    var authenticated: URLRequest {
        var request = URLRequest(url: url)
        request.setupUserAgentHeader(nationName: self.authenticationContainer.nationName)
        
        if let pin = self.authenticationContainer.pin {
            request.setupPinHeader(pin)
        } else if let autologin = self.authenticationContainer.autologin {
            request.setupAutologinHeader(autologin)
        } else {
            request.setupPasswordAuthenticationHeader(self.authenticationContainer.password)
        }
        
        print("API Request with url \(url.absoluteString) with headers: \(request.allHTTPHeaderFields ?? [:])")
        
        return request
    }
    
    var publisher: AnyPublisher<DataResponse, APIError> {
        self.session.publisher(for: self.authenticated)
            .tryMap({ output -> DataResponse in
                try self.throwHTTPErrors(output)
                return output
            })
            .tryCatch({ error -> AnyPublisher<DataResponse, APIError> in
                guard let apiError = error as? APIError, self.authenticationContainer.pin != nil || self.authenticationContainer.autologin != nil else {
                    throw error
                }
                
                switch apiError {
                case .conflict:
                    print("HTTP call failed with 409, retrying without PIN header")
                    self.authenticationContainer.pin = nil
                    return APIRequest(url: self.url, authenticationContainer: self.authenticationContainer, session: self.session).publisher
                case .unauthorized:
                    print("HTTP call failed with 403, retrying without PIN header and autologin")
                    self.authenticationContainer.pin = nil
                    self.authenticationContainer.autologin = nil
                    return APIRequest(url: self.url, authenticationContainer: self.authenticationContainer, session: self.session).publisher
                default: throw apiError
                }
                
            })
            .mapError({ (error) -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                }
                if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                    return APIError.notConnected
                }
                return APIError.unknown(error: error)
            })
            .handleEvents(receiveOutput: { output in
                if let httpResponse = output.response as? HTTPURLResponse {
                    if let autoLogin = httpResponse.value(forHTTPHeaderField: AuthenticationMode.autologin.header) {
                        self.authenticationContainer.autologin = autoLogin
                        print("Set auth AUTOLOGIN")
                    }
                    if let pin = httpResponse.value(forHTTPHeaderField: AuthenticationMode.pin.header) {
                        self.authenticationContainer.pin = pin
                        print("Set auth PIN")
                    }
                }
            })
            .eraseToAnyPublisher()
    }
}

extension APIRequest {
    private func throwHTTPErrors(_ output: DataResponse) throws {
        if let httpResponse = output.response as? HTTPURLResponse {
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
        }
    }
}
