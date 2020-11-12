//
//  APIRequestTests.swift
//  NationStatesClientTests
//
//  Created by Bart Kneepkens on 04/11/2020.
//

import XCTest
import Combine
@testable import NationStatesClient

fileprivate class MockedSecureStorage: SecureStorage {
    func store(_ value: String?, key: String) {
        
    }
    
    func retrieve(key: String) -> String? {
        return ""
    }
}

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

class APIRequest_AuthenticationHeaders_Tests: XCTestCase {
    func testPasswordHeader() throws {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password")
        let request = APIRequest(url: mockURL, authenticationContainer: container).authenticated
        
        XCTAssertEqual(getPasswordHeader(request), "test_password")
        XCTAssertNil(getAutologinHeader(request))
        XCTAssertNil(getPinHeader(request))
    }
    
    func testPinHeader() {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password", pin: "test_pin")
        let request = APIRequest(url: mockURL, authenticationContainer: container).authenticated
        
        XCTAssertEqual(getPinHeader(request), "test_pin")
        XCTAssertNil(getPasswordHeader(request))
        XCTAssertNil(getAutologinHeader(request))
    }
    
    func testAutologinHeader() {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password", autologin: "test_autologin")
        let request = APIRequest(url: mockURL, authenticationContainer: container).authenticated
        
        XCTAssertEqual(getAutologinHeader(request), "test_autologin")
        XCTAssertNil(getPinHeader(request))
        XCTAssertNil(getPasswordHeader(request))
    }
    
    func testHeaderPriority() {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password", pin: "test_pin", autologin: "test_autologin")
        var request = APIRequest(url: mockURL, authenticationContainer: container).authenticated
        
        // Should use pin if all values are available
        XCTAssertEqual(getPinHeader(request), "test_pin")
        XCTAssertNil(getAutologinHeader(request))
        XCTAssertNil(getPasswordHeader(request))
        
        container.pin = nil
        request = APIRequest(url: mockURL, authenticationContainer: container).authenticated
        
        // Should use autologin if pin is not available
        XCTAssertEqual(getAutologinHeader(request), "test_autologin")
        XCTAssertNil(getPinHeader(request))
        XCTAssertNil(getPasswordHeader(request))
        
        container.autologin = nil
        request = APIRequest(url: mockURL, authenticationContainer: container).authenticated
        
        // Should use password if neither pin and autologin is available
        XCTAssertEqual(getPasswordHeader(request), "test_password")
        XCTAssertNil(getAutologinHeader(request))
        XCTAssertNil(getPinHeader(request))
    }
    
    private func getPasswordHeader(_ request: URLRequest) -> String? {
        return request.value(forHTTPHeaderField: "X-Password")
    }
    
    private func getPinHeader(_ request: URLRequest) -> String? {
        return request.value(forHTTPHeaderField: "X-pin")
    }
    
    private func getAutologinHeader(_ request: URLRequest) -> String? {
        return request.value(forHTTPHeaderField: "X-autologin")
    }
}

class APIRequest_Publisher_HTTP_Errors_Tests: XCTestCase {
    class MockedSession: NetworkSession {
        var statusCode: Int
        
        init(statusCode: Int) {
            self.statusCode = statusCode
        }
        
        func publisher(for request: URLRequest) -> AnyPublisher<DataResponse, URLError> {
            let httpResponse = HTTPURLResponse(url: mockURL, statusCode: self.statusCode, httpVersion: nil, headerFields: nil)!
            return Just((data: Data(), response: httpResponse))
                .mapError({ failure -> URLError in })
                .eraseToAnyPublisher()
        }
    }
    
    func testHTTPError403() throws {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password")
        let expectation = self.expectation(description: "throws APIError .unauthorized in case of HTTP error 403")
        
        let _ = APIRequest(url: mockURL, authenticationContainer: container, session: MockedSession(statusCode: 403))
            .publisher
            .sink { completion in
                switch completion {
                case .failure(let apiError):
                    switch apiError {
                    case .unauthorized:
                        expectation.fulfill()
                    default: break
                    }
                default: break
                }
            } receiveValue: { _ in }
        
        self.waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testHTTPError409() throws {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password")
        let expectation = self.expectation(description: "throws APIError .conflict in case of HTTP error 409")
        
        let _ = APIRequest(url: mockURL, authenticationContainer: container, session: MockedSession(statusCode: 409))
            .publisher
            .sink { completion in
                switch completion {
                case .failure(let apiError):
                    switch apiError {
                    case .conflict:
                        expectation.fulfill()
                    default: break
                    }
                default: break
                }
            } receiveValue: { _ in }
        
        self.waitForExpectations(timeout: 1, handler: nil)
    }
}

class APIRequest_Publisher_NSErrors_Tests: XCTestCase {
    class MockedSession: NetworkSession {
        func publisher(for request: URLRequest) -> AnyPublisher<DataResponse, URLError> {
            return Fail(error: URLError(URLError.notConnectedToInternet))
                .eraseToAnyPublisher()
        }
    }
    
    func testNotConnected() throws {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password")
        let expectation = self.expectation(description: "throws APIError .notConnected in case of URL error NSURLErrorNotConnectedToInternet")
        
        let _ = APIRequest(url: mockURL, authenticationContainer: container, session: MockedSession())
            .publisher
            .sink { completion in
                switch completion {
                case .failure(let apiError):
                    switch apiError {
                    case .notConnected:
                        expectation.fulfill()
                    default: break
                    }
                default: break
                }
            } receiveValue: { _ in }
        
        self.waitForExpectations(timeout: 1, handler: nil)
    }
}

class APIRequest_Publisher_Retry_Mechanism_Tests: XCTestCase {
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
    }
    
    func testRetryHTTP409() {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password", pin: "test_pin", autologin: "test_autologin")
        let session = MockedSession(statusCodes: [409, 200])
        
        let pinHeaderExpectation = self.expectation(description: "Removes pin header after first failure")
        let autologinHeaderExpectation = self.expectation(description: "Autologin header still available after first failure")
        let amountOfCallsExpectation = self.expectation(description: "Should be called exactly twice")
        
        let _ = APIRequest(url: mockURL, authenticationContainer: container, session: session)
            .publisher
            .sink { completion in
                switch completion {
                case .finished:
                    if container.pin == nil {
                        pinHeaderExpectation.fulfill()
                    }
                    if container.autologin == "test_autologin" {
                        autologinHeaderExpectation.fulfill()
                    }
                    if session.counter == 2 {
                        amountOfCallsExpectation.fulfill()
                    }
                default: break
                }
            } receiveValue: { output in }
        
        self.waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testRetryHTTP403() {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password", pin: "test_pin", autologin: "test_autologin")
        let session = MockedSession(statusCodes: [403, 200])
        
        let authenticationHeadersExpectation = self.expectation(description: "Removes pin and autologin header after first failure")
        let passwordHeaderExpectation = self.expectation(description: "Uses password header after first failure")
        let amountOfCallsExpectation = self.expectation(description: "Should be called exactly twice")
        
        let _ = APIRequest(url: mockURL, authenticationContainer: container, session: session)
            .publisher
            .sink { completion in
                switch completion {
                case .finished:
                    if container.pin == nil && container.autologin == nil {
                        authenticationHeadersExpectation.fulfill()
                    }
                    if container.password == "test_password" {
                        passwordHeaderExpectation.fulfill()
                    }
                    if session.counter == 2 {
                        amountOfCallsExpectation.fulfill()
                    }
                default: break
                }
            } receiveValue: { output in }
        
        self.waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testRetryHTTP409AndThen403() {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password", pin: "test_pin", autologin: "test_autologin")
        let session = MockedSession(statusCodes: [409, 403, 200])
        
        let authenticationHeadersExpectation = self.expectation(description: "Has removed pin and autologin")
        let passwordHeaderExpectation = self.expectation(description: "Uses password")
        
        let amountOfCallsExpectation = self.expectation(description: "Should be called exactly thrice")
        
        let _ = APIRequest(url: mockURL, authenticationContainer: container, session: session)
            .publisher
            .sink { completion in
                switch completion {
                case .finished:
                    if container.pin == nil && container.autologin == nil {
                        authenticationHeadersExpectation.fulfill()
                    }
                    if container.password == "test_password" {
                        passwordHeaderExpectation.fulfill()
                    }
                    if session.counter == 3 {
                        amountOfCallsExpectation.fulfill()
                    }
                default: break
                }
            } receiveValue: { output in }
        
        self.waitForExpectations(timeout: 1, handler: nil)
    }
}

class APIRequest_Publisher_AuthenticationContainer_Tests: XCTestCase {
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
    }
    
    func testAuthenticationContainer() {
        let container = authenticationContainerWith(nationName: "test_nationName", password: "test_password")
        let session = MockedSession(statusCodes: [200])
        
        XCTAssertNil(container.pin)
        XCTAssertNil(container.autologin)
    
        let expectation = self.expectation(description: "Has set `pair` (pin and autologin) on the AuthenticationContainer")

        let _ = APIRequest(url: mockURL, authenticationContainer: container, session: session)
            .publisher
            .sink { completion in
                switch completion {
                case .finished:
                    if container.autologin == "test_autologin" && container.pin == "test_pin" {
                        expectation.fulfill()
                    }
                    
                default: break
                }
            } receiveValue: { output in }
        
        self.waitForExpectations(timeout: 1, handler: nil)
    }
}
