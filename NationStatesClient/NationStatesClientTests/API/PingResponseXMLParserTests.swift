//
//  PingResponseXMLParserTests.swift
//  NationStatesClientTests
//
//  Created by Bart Kneepkens on 12/10/2020.
//

import XCTest
@testable import NationStatesClient

class PingResponseXMLParserTests: XCTestCase {
    
    let PING_0_RESPONSE = """
        <NATION id="nation">
            <PING>0</PING>
        </NATION>
    """
    
    let PING_1_RESPONSE = """
        <NATION id="nation">
            <PING>1</PING>
        </NATION>
    """
    
    func testInvalidResponse() {
        let parser = PingResponseXMLParser("<PING>3<INVALID>".data(using: .utf8)!)
        parser.parse()
        XCTAssert(parser.ping == false)
    }

    func testPing0Response() throws {
        let parser = PingResponseXMLParser(PING_0_RESPONSE.data(using: .utf8)!)
        parser.parse()
        XCTAssert(parser.ping == false)
    }
    
    func testPing1Response() throws {
        let parser = PingResponseXMLParser(PING_1_RESPONSE.data(using: .utf8)!)
        parser.parse()
        XCTAssert(parser.ping == true)
    }
}
