//
//  NationStatesClientUITests.swift
//  NationStatesClientUITests
//
//  Created by Bart Kneepkens on 07/10/2020.
//

import XCTest

class NationStatesClientUITests: XCTestCase {
    
    func testRunForScreenshots() {
        let app = XCUIApplication()
        app.launch()
        setupSnapshot(app)
        snapshot("IssuesScreen")
                        
    }
}
