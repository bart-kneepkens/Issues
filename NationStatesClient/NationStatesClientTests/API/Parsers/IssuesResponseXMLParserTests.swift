//
//  IssuesResponseXMLParserTests.swift
//  NationStatesClientTests
//
//  Created by Bart Kneepkens on 25/10/2020.
//

import XCTest
@testable import NationStatesClient

class IssuesResponseXMLParserTests: XCTestCase {
    
    let OK_RESPONSE = """
    <NATION id="elest_adra">
    <ISSUES>
    <ISSUE id="668">
    <TITLE>First Issue Title</TITLE>
    <TEXT>First Issue text</TEXT>
    <AUTHOR>averycoolauthor</AUTHOR>
    <EDITOR>averycoolauthor</EDITOR>
    <PIC1>p63</PIC1>
    <PIC2>q1</PIC2>
    <OPTION id="0">First issue, first option</OPTION>
    <OPTION id="1">First issue, second option</OPTION>
    <OPTION id="2">First issue, third option</OPTION>
    <OPTION id="3">First issue, fourth option</OPTION>
    </ISSUE>
    <ISSUE id="222">
    <TITLE>Second Issue Title</TITLE>
    <TEXT>Second Issue text</TEXT>
    <AUTHOR>averycoolauthor2</AUTHOR>
    <EDITOR>averycoolauthor2</EDITOR>
    <PIC1>p63</PIC1>
    <PIC2>q1</PIC2>
    <OPTION id="0">Second issue, first option</OPTION>
    <OPTION id="1">Second issue, second option</OPTION>
    </ISSUE>
    </ISSUES>
    </NATION>
    """
    
    func testOkResponse() throws {
        let parser = IssuesResponseXMLParser(OK_RESPONSE.data(using: .utf8)!)
        parser.parse()
        
        XCTAssertEqual(parser.issues, [
            .init(id: 668, title: "First Issue Title", author: "averycoolauthor", editor: "averycoolauthor", pic1: "p63", pic2: "q1", text: "First Issue text", options: [
                .init(id: 0, text: "First issue, first option"),
                .init(id: 1, text: "First issue, second option"),
                .init(id: 2, text: "First issue, third option"),
                .init(id: 3, text: "First issue, fourth option"),
            ]),
            .init(id: 222, title: "Second Issue Title", author: "averycoolauthor2", editor: "averycoolauthor2", pic1: "p63", pic2: "q1", text: "Second Issue text", options: [
                .init(id: 0, text: "Second issue, first option"),
                .init(id: 1, text: "Second issue, second option")
            ]),
            
        ])
    }
    
}
