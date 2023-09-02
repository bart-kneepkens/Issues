//
//  NetworkSession.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 22/12/2020.
//

import Foundation
import Combine

protocol NetworkSession {
    func publisher(for request: URLRequest) -> AnyPublisher<DataResponse, URLError>
    func asyncData(for request: URLRequest) async throws -> DataResponse
}

extension URLSession: NetworkSession {
    func publisher(for request: URLRequest) -> AnyPublisher<DataResponse, URLError> {
        return self.dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
    
    func asyncData(for request: URLRequest) async throws -> DataResponse {
        return try await data(for: request)
    }
}
