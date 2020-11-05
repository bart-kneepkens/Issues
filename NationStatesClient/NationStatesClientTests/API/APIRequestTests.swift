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
    
    if autologin == nil && pin == nil {
        container.pair = nil
    } else {
        container.pair = (autologin: autologin, pin: pin)
    }
    
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
        
        XCTAssertEqual(getPinHeader(request), "test_pin")
        XCTAssertNil(getAutologinHeader(request))
        XCTAssertNil(getPasswordHeader(request))
        
        container.pair?.pin = nil
        request = APIRequest(url: mockURL, authenticationContainer: container).authenticated
        
        XCTAssertEqual(getAutologinHeader(request), "test_autologin")
        XCTAssertNil(getPinHeader(request))
        XCTAssertNil(getPasswordHeader(request))
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
