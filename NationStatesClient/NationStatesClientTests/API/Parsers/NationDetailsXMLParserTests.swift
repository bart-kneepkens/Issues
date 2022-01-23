//
//  NationDetailsXMLParserTests.swift
//  NationStatesClientTests
//
//  Created by Bart Kneepkens on 24/11/2020.
//

import XCTest
@testable import NationStatesClient

class NationDetailsXMLParserTests: XCTestCase {
    
    let RESPONSE = """
    <NATION id="elest_adra">
    <TYPE>Democratic Republic</TYPE>
    <NAME>Elest Adra</NAME>
    <FULLNAME>The Democratic Republic of Elest Adra</FULLNAME>
    <MOTTO>Strength Through Freedom</MOTTO>
    <CATEGORY>Capitalizt</CATEGORY>
    <FREEDOM>
    <CIVILRIGHTS>Superb</CIVILRIGHTS>
    <ECONOMY>Very Strong</ECONOMY>
    <POLITICALFREEDOM>Very Good</POLITICALFREEDOM>
    </FREEDOM>
    <FLAG>https://www.nationstates.net/images/flags/Djibouti.png</FLAG>
    <CENSUS>
    <SCALE id="0">
    <SCORE>74.77</SCORE>
    <RANK>40212</RANK>
    <RRANK>785</RRANK>
    </SCALE>
    <SCALE id="1">
    <SCORE>75.33</SCORE>
    <RANK>77058</RANK>
    <RRANK>3541</RRANK>
    </SCALE>
    <SCALE id="2">
    <SCORE>67.43</SCORE>
    <RANK>86713</RANK>
    <RRANK>2416</RRANK>
    </SCALE>
    </CENSUS>
    </NATION>
    """
    
    func testOkResponse() throws {
        let parser = NationDetailsResponseXMLParser(RESPONSE.data(using: .utf8)!)
        parser.parse()
        
        XCTAssertEqual(parser.nationDTO, NationDTO(flagURL: "https://www.nationstates.net/images/flags/Djibouti.png", name: "Elest Adra", fullName: "The Democratic Republic of Elest Adra", motto: "Strength Through Freedom", category: "Capitalizt", type: "Democratic Republic", freedoms: FreedomsDTO(civilRights: .init(score: 74.77, rank: 40212, regionRank: 785, text: "Superb"), economy: .init(score: 75.33, rank: 77058, regionRank: 3541, text: "Very Strong"), politicalFreedom: .init(score: 67.43, rank: 86713, regionRank: 2416, text: "Very Good"))))
    }
    
    let RESPONSE_UNICODE_MOTTO = """
    <NATION id="elest_adra">
    <MOTTO>eat the rich &#xB0;&#x26;#726;&#x26;#10023;&#x26;#9693;(&#x26;#8304;&#x26;#9663;&#x26;#8304;)&#x26;#9692;&#x26;#10023;&#x26;#726;&#xB0;</MOTTO>
    </NATION>
    """
    
    func testUnicodeMotto() {
        let parser = NationDetailsResponseXMLParser(RESPONSE_UNICODE_MOTTO.data(using: .utf8)!)
        parser.parse()
        
        XCTAssertEqual(parser.nationDTO.motto, "eat the rich °˖✧◝(⁰▿⁰)◜✧˖°")
    }
    
    let RESPONSE_WITH_SVG_FLAG = """
    <NATION id="elest_adra">
    <FLAG>https://www.nationstates.net/images/flags/Djibouti.svg</FLAG>
    </NATION>
    """
    
    func testSVGFlagURL() {
        let parser = NationDetailsResponseXMLParser(RESPONSE_WITH_SVG_FLAG.data(using: .utf8)!)
        parser.parse()
        
        XCTAssertEqual(parser.nationDTO.flagURL, "https://www.nationstates.net/images/flags/Djibouti.png")
    }
}
