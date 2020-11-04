//
//  APIRequestTests.swift
//  NationStatesClientTests
//
//  Created by Bart Kneepkens on 04/11/2020.
//

import XCTest
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

private func getPasswordHeader(_ request: URLRequest) -> String? {
    return request.value(forHTTPHeaderField: "X-Password")
}

private func getPinHeader(_ request: URLRequest) -> String? {
    return request.value(forHTTPHeaderField: "X-pin")
}

private func getAutologinHeader(_ request: URLRequest) -> String? {
    return request.value(forHTTPHeaderField: "X-autologin")
}

class APIRequest_AuthenticationHeaders_Tests: XCTestCase {
    let mockURL = URL(string: "test_url")!
    
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
}
