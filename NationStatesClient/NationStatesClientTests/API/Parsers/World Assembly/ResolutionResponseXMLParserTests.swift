//
//  ResolutionResponseXMLParserTests.swift
//  NationStatesClientTests
//
//  Created by Bart Kneepkens on 30/12/2020.
//

import XCTest
@testable import NationStatesClient

class ResolutionResponseXMLParserTests: XCTestCase {
    
    let RESOLUTION_RESPONSE = """
     <WA council="1">
     <RESOLUTION>
     <CATEGORY>Regulation</CATEGORY>
     <CREATED>1608621807</CREATED>
     <DESC>
     <![CDATA[A Very long and interesting description text]]>
     </DESC>
     <ID>merni_1608621807</ID>
     <NAME>Repeal &quot;Commend The Western Isles&quot;</NAME>
     <OPTION>Safety</OPTION>
     <PROMOTED>1609261203</PROMOTED>
     <PROPOSED_BY>merni</PROPOSED_BY>
     <TOTAL_NATIONS_AGAINST>159</TOTAL_NATIONS_AGAINST>
     <TOTAL_NATIONS_FOR>410</TOTAL_NATIONS_FOR>
     <TOTAL_VOTES_AGAINST>1067</TOTAL_VOTES_AGAINST>
     <TOTAL_VOTES_FOR>1536</TOTAL_VOTES_FOR>
     </RESOLUTION>
     </WA>
     */
    """

    func testValidResponse() {
        let parser = ResolutionResponseXMLParser(RESOLUTION_RESPONSE.data(using: .utf8)!)
        parser.parse()
        
        XCTAssertEqual(parser.resolution, ResolutionDTO(category: "Regulation",
                                                        created: Date(timeIntervalSince1970: TimeInterval(1608621807)),
                                                        id: "merni_1608621807",
                                                        name: "Repeal \"Commend The Western Isles\"",
                                                        option: "Safety",
                                                        promoted: Date(timeIntervalSince1970: TimeInterval(1609261203)),
                                                        proposedBy: "merni",
                                                        totalVotesAgainst: 1067,
                                                        totalVotesFor: 1536))
    }

}
