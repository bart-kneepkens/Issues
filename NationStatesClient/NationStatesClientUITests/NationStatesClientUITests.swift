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
        setupSnapshot(app)
        app.launch()
        // Initial screen
        snapshot("IssuesScreen")
        
        // Tap Issue
        app.cells.firstMatch.tap()
        
        snapshot("Issue Detail")
        
        app.buttons["Respond to this issue"].tap()
        
        snapshot("Issue Responses")
        let topCoordinate = app.cells.firstMatch.coordinate(withNormalizedOffset: .zero)
        topCoordinate.press(forDuration: 0.2, thenDragTo: topCoordinate.withOffset(.init(dx: 0, dy: 500)), withVelocity: .fast, thenHoldForDuration: 0.5)
        
        app.buttons["World Assembly"].tap()
        snapshot("World Assembly")
        
        app.cells.firstMatch.tap()
        snapshot("World Assembly Detail")
        
        app.buttons["Nation"].tap()
        snapshot("Nation View")
    }
}
