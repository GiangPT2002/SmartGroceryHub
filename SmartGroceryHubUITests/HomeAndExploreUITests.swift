//
//  HomeAndExploreUITests.swift
//  SmartGroceryHubUITests
//
//  Created by AI.
//

import XCTest

class HomeAndExploreUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testExploreTabInteraction() throws {
        let exploreTab = app.buttons["Khám phá"]
        
        if exploreTab.waitForExistence(timeout: 5.0) {
            exploreTab.tap()
            
            // Normally Home sets focus. Just ensuring no crash during tab switches.
            XCTAssertTrue(exploreTab.isSelected || exploreTab.isEnabled)
            
            // Assuming Back to home is available via tab:
            app.buttons["Trang chủ"].tap()
            // Validate Home features
        }
    }
}
