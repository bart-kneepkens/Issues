//
//  AnswerIssueResponseXMLParserTests.swift
//  NationStatesClientTests
//
//  Created by Bart Kneepkens on 11/10/2020.
//

import XCTest
@testable import NationStatesClient

class AnswerIssueResponseXMLParserTests: XCTestCase {
    
    let OK_RESPONSE = """
        <NATION id="elest_adra">
    <ISSUE id="991" choice="1">
        <OK>1</OK>
        <DESC>charities reserve the right to not help those who go against religious teachings</DESC>
        <RANKINGS>
            <RANK id="1">
                <SCORE>73.75</SCORE>
                <CHANGE>0.50</CHANGE>
                <PCHANGE>0.673401</PCHANGE>
            </RANK>
            <RANK id="4">
                <SCORE>15.81</SCORE>
                <CHANGE>-0.46</CHANGE>
                <PCHANGE>-2.827289</PCHANGE>
            </RANK>
        </RANKINGS>
        <RECLASSIFICATIONS>
            <RECLASSIFY type="1">
                <FROM>Very Strong</FROM>
                <TO>Strong</TO>
            </RECLASSIFY>
        </RECLASSIFICATIONS>
        <HEADLINES>
            <HEADLINE>Leader Honored With New Statue </HEADLINE>
            <HEADLINE>Modern Generation Lacks Patience, Artisan Basket Weavers Say</HEADLINE>
            <HEADLINE>Military Base Converted To Well-Defended Retirement Village</HEADLINE>
            <HEADLINE>Demonstration Ends In Reasonable Discussion, Handshakes</HEADLINE>
        </HEADLINES>
    </ISSUE>
    </NATION>
    """
    
    func testOkResponse() throws {
        let parser = AnswerIssueResponseXMLParser(OK_RESPONSE.data(using: .utf8)!)
        parser.parse()
        
        XCTAssert(parser.ok == true)
        XCTAssert(parser.text == "Charities reserve the right to not help those who go against religious teachings.")
        XCTAssertEqual(parser.rankings, [
            .init(id: 1, score: 73.75, change: 0.50, percentualChange: 0.673401),
            .init(id: 4, score: 15.81, change: -0.46, percentualChange: -2.827289)
        ])
        XCTAssertEqual(parser.reclassifications, [
            .init(type: 1, from: "Very Strong", to: "Strong")
        ])
        XCTAssertEqual(parser.headlines, [
            "Leader Honored With New Statue",
            "Modern Generation Lacks Patience, Artisan Basket Weavers Say",
            "Military Base Converted To Well-Defended Retirement Village",
            "Demonstration Ends In Reasonable Discussion, Handshakes",
        ])
    }
    
}
