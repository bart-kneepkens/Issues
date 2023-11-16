//
//  NationStatesClientUITests.swift
//  NationStatesClientUITests
//
//  Created by Bart Kneepkens on 07/10/2020.
//

import XCTest

class NationStatesClientUITests: XCTestCase {
    
    class Robot {
        let app: XCUIApplication
        
        init(_ app: XCUIApplication) {
            self.app = app
            setupSnapshot(app)
            app.launch()
        }
        
        func takeScreenshot(name: String) {
            snapshot(name)
        }
        
        func tapFirstIssue() {
            app.cells.firstMatch.tap()
        }
        
        func tapRespondToThisIssue() {
            app.buttons["Respond to this issue"].tap()
        }
        
        func swipeAwayResponseSheet() {
            let topCoordinate = app.cells.firstMatch.coordinate(withNormalizedOffset: .zero)
            topCoordinate.press(forDuration: 0.2, thenDragTo: topCoordinate.withOffset(.init(dx: 0, dy: 1500)), withVelocity: .fast, thenHoldForDuration: 0.5)
        }
        
        func tapWorldAssemblyTabBarItem() {
            app.buttons["World Assembly"].tap()
        }
        
        func tapFirstWorldAssemblyResolution() {
            app.cells.firstMatch.tap()
        }
        
        func tapNationTabBarItem() {
            app.buttons["Nation"].tap()
        }
        
        func tapRegionTabBarItem() {
            app.buttons["Region"].tap()
        }
    }
    
    func testRunForScreenshots() {
        let app = XCUIApplication()
        let robot = Robot(app)
    
        robot.takeScreenshot(name: "home screen")
        
        robot.tapFirstIssue()
        
        robot.takeScreenshot(name: "issue screen")
        
        robot.tapRespondToThisIssue()
        
        robot.takeScreenshot(name: "issue responses")
        
        robot.swipeAwayResponseSheet()
        
        robot.tapWorldAssemblyTabBarItem()
        robot.tapFirstWorldAssemblyResolution()
            
        robot.takeScreenshot(name: "world assembly")
        
        robot.tapNationTabBarItem()
        robot.takeScreenshot(name: "nation")
        
        robot.tapRegionTabBarItem()
        
        robot.takeScreenshot(name: "region")
    }
}
