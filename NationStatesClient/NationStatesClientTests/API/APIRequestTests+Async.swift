//
//  AuthenticatedAPIRequestTests+Async.swift
//  NationStatesClientTests
//
//  Created by Bart Kneepkens on 03/09/2023.
//

import XCTest
import Combine
@testable import NationStatesClient

private func authenticationContainerWith(nationName: String = "",
                                         password: String = "",
                                         pin: String? = nil,
                                         autologin: String? = nil) -> AuthenticationContainer {
    let container = AuthenticationContainer(storage: MockedSecureStorage())
    container.nationName = nationName
    container.password = password
    container.pin = pin
    container.autologin = autologin
    
    return container
}

private let mockURL = URL(string: "test_url")!

class AuthenticatedAPIRequest_Async_HTTP_Errors_Tests: XCTestCase {
    class MockedSession: NetworkSession {
        let httpResponse: HTTPURLResponse
        
        init(statusCode: Int) {
            httpResponse = HTTPURLResponse(url: mockURL, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        }
        
        func publisher(for request: URLRequest) -> AnyPublisher<DataResponse, URLError> {
            Just((data: Data(), response: httpResponse))
                .mapError({ failure -> URLError in })
                .eraseToAnyPublisher()
        }
        
        func asyncData(for request: URLRequest) async throws -> NationStatesClient.DataResponse {
            (Data(), httpResponse)
        }
    }
    
    func testHTTPError403() async throws {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password")
        let expectation = self.expectation(description: "throws APIError .unauthorized in case of HTTP error 403")
        
        do {
            let _ = try await AuthenticatedAPIRequest(url: mockURL, authenticationContainer: container, session: MockedSession(statusCode: 403))
                .response
        } catch {
            switch error.asAPIError {
            case .unauthorized:
                expectation.fulfill()
            default:
                break
            }
        }
            
        await fulfillment(of: [expectation])
    }
    
    func testHTTPError409() async throws {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password")
        let expectation = self.expectation(description: "throws APIError .conflict in case of HTTP error 409")
        
        do {
            let _ = try await AuthenticatedAPIRequest(url: mockURL, authenticationContainer: container, session: MockedSession(statusCode: 409))
                .response
        } catch {
            switch error.asAPIError {
            case .conflict:
                expectation.fulfill()
            default:
                break
            }
        }
            
        await fulfillment(of: [expectation])
    }
    
    func testHTTPError404() async throws {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password")
        let expectation = self.expectation(description: "throws APIError .notFound in case of HTTP error 404")
        
        do {
            let _ = try await AuthenticatedAPIRequest(url: mockURL, authenticationContainer: container, session: MockedSession(statusCode: 404))
                .response
        } catch {
            switch error.asAPIError {
            case .notFound:
                expectation.fulfill()
            default:
                break
            }
        }
            
        await fulfillment(of: [expectation])
    }
    
    func testHTTPError429() async throws {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password")
        let expectation = self.expectation(description: "throws APIError .rateExceeded in case of HTTP error 429")
        
        do {
            let _ = try await AuthenticatedAPIRequest(url: mockURL, authenticationContainer: container, session: MockedSession(statusCode: 429))
                .response
        } catch {
            switch error.asAPIError {
            case .rateExceeded:
                expectation.fulfill()
            default:
                break
            }
        }
            
        await fulfillment(of: [expectation])
    }
}

class AuthenticatedAPIRequest_Async_NSErrors_Tests: XCTestCase {
    class MockedSession: NetworkSession {
        let urlError: URLError
        
        init(_ urlErrorCode: URLError.Code) {
            self.urlError = URLError(urlErrorCode)
        }
        
        func publisher(for request: URLRequest) -> AnyPublisher<DataResponse, URLError> {
            Fail(error: urlError).eraseToAnyPublisher()
        }
        
        func asyncData(for request: URLRequest) async throws -> NationStatesClient.DataResponse {
            throw urlError
        }
    }
    
    func testNotConnected() async throws {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password")
        let expectation = self.expectation(description: "throws APIError .notConnected in case of URL error NSURLErrorNotConnectedToInternet")
        
        do {
            let _ = try await AuthenticatedAPIRequest(url: mockURL, authenticationContainer: container, session: MockedSession(URLError.notConnectedToInternet))
                .response
        } catch {
            switch error.asAPIError {
            case .notConnected:
                expectation.fulfill()
            default:
                break
            }
        }
            
        await fulfillment(of: [expectation])
    }
    
    func testTimedOut() async throws {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password")
        let expectation = self.expectation(description: "throws APIError .timedOut in case of URL error NSURLErrorTimedOut")
        
        do {
            let _ = try await AuthenticatedAPIRequest(url: mockURL, authenticationContainer: container, session: MockedSession(URLError.timedOut))
                .response
        } catch {
            switch error.asAPIError {
            case .timedOut:
                expectation.fulfill()
            default:
                break
            }
        }
            
        await fulfillment(of: [expectation])
    }
}

class AuthenticatedAPIRequest_Async_Retry_Mechanism_Tests: XCTestCase {
    class MockedSession: NetworkSession {
        var statusCodes: [Int]
        var counter = 0
        
        init(statusCodes: [Int]) {
            self.statusCodes = statusCodes
        }
        
        func publisher(for request: URLRequest) -> AnyPublisher<DataResponse, URLError> {
            let httpResponse = HTTPURLResponse(url: mockURL, statusCode: self.statusCodes[counter], httpVersion: nil, headerFields: nil)!
            counter += 1
            
            return Just((data: Data(), response: httpResponse))
                .mapError({ failure -> URLError in })
                .eraseToAnyPublisher()
        }
        
        func asyncData(for request: URLRequest) async throws -> NationStatesClient.DataResponse {
            let httpResponse = HTTPURLResponse(url: mockURL, statusCode: self.statusCodes[counter], httpVersion: nil, headerFields: nil)!
            counter += 1
            return (Data(), httpResponse)
        }
    }
    
    func testRetryHTTP409() async throws {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password", pin: "test_pin", autologin: "test_autologin")
        let session = MockedSession(statusCodes: [409, 200])
        
        let _ = try await AuthenticatedAPIRequest(url: mockURL, authenticationContainer: container, session: session).response
        
        XCTAssertNil(container.pin, "Removes pin header after first failure")
        XCTAssertEqual(container.autologin, "test_autologin", "Autologin header still available after first failure")
        XCTAssertEqual(session.counter, 2, "Should be called exactly twice")
    }
    
    func testRetryHTTP403() async throws {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password", pin: "test_pin", autologin: "test_autologin")
        let session = MockedSession(statusCodes: [403, 200])
        
        let _ = try await AuthenticatedAPIRequest(url: mockURL, authenticationContainer: container, session: session).response
        
        XCTAssertNil(container.pin, "Removes pin header after first failure")
        XCTAssertNil(container.autologin, "Removes autologin header after first failure")
        XCTAssertEqual(container.password, "test_password", "Uses password header after first failure")
        XCTAssertEqual(session.counter, 2, "Should be called exactly twice")
    }
    
    func testRetryHTTP409AndThen403() async throws {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password", pin: "test_pin", autologin: "test_autologin")
        let session = MockedSession(statusCodes: [409, 403, 200])
        
        let _ = try await AuthenticatedAPIRequest(url: mockURL, authenticationContainer: container, session: session).response
        
        XCTAssertNil(container.pin, "Removes pin header after first failure")
        XCTAssertNil(container.autologin, "Removes autologin header after first failure")
        XCTAssertEqual(container.password, "test_password", "Uses password header after first failure")
        XCTAssertEqual(session.counter, 3, "Should be called exactly thrice")
    }
}

class AuthenticatedAPIRequest_Async_AuthenticationContainer_Tests: XCTestCase {
    class MockedSession: NetworkSession {
        var statusCodes: [Int]
        var counter = 0
        
        init(statusCodes: [Int]) {
            self.statusCodes = statusCodes
        }
        
        func publisher(for request: URLRequest) -> AnyPublisher<DataResponse, URLError> {
            let httpResponse = HTTPURLResponse(url: mockURL, statusCode: self.statusCodes[counter], httpVersion: nil, headerFields: ["X-pin" : "test_pin", "X-autologin": "test_autologin"])!
            counter += 1
            
            return Just((data: Data(), response: httpResponse))
                .mapError({ failure -> URLError in })
                .eraseToAnyPublisher()
        }
        
        func asyncData(for request: URLRequest) async throws -> NationStatesClient.DataResponse {
            let httpResponse = HTTPURLResponse(url: mockURL, statusCode: self.statusCodes[counter], httpVersion: nil, headerFields: ["X-pin" : "test_pin", "X-autologin": "test_autologin"])!
            counter += 1
            return (Data(), httpResponse)
        }
    }
    
    func testAuthenticationContainer() async throws {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password")
        let session = MockedSession(statusCodes: [200])
        
        XCTAssertNil(container.pin)
        XCTAssertNil(container.autologin)

        let _ = try await AuthenticatedAPIRequest(url: mockURL, authenticationContainer: container, session: session)
            .response
            
        XCTAssertEqual(container.autologin, "test_autologin", "Has set `pair` (pin and autologin) on the AuthenticationContainer")
        XCTAssertEqual(container.pin, "test_pin", "Has set `pair` (pin and autologin) on the AuthenticationContainer")
    }
}
