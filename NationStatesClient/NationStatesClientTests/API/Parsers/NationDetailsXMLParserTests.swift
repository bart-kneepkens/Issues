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
        
        XCTAssertEqual(parser.nationDTO, NationDTO(flagURL: "https://www.nationstates.net/images/flags/Djibouti.png", name: "Elest Adra", fullName: "The Democratic Republic of Elest Adra", motto: "Strength Through Freedom", category: "Capitalizt", type: "Democratic Republic", freedom: .init(civilRights: "Superb", economy: "Very Strong", politicalFreedom: "Very Good")))
    }
}
