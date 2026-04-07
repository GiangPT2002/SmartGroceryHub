//
//  AccountUITests.swift
//  SmartGroceryHubUITests
//
//  Created by AI.
//

import XCTest

class AccountUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testAccountAndLogoutNavigation() throws {
        let accountTab = app.buttons["Tài khoản"]
        
        if accountTab.waitForExistence(timeout: 5.0) {
            accountTab.tap()
            
            // Check Account UI features
            XCTAssertTrue(app.staticTexts["Thông báo"].waitForExistence(timeout: 2.0))
            XCTAssertTrue(app.staticTexts["Trợ giúp"].exists)
            
            // Trigger logout process
            let logoutBtn = app.buttons["Đăng xuất"]
            if logoutBtn.exists {
                logoutBtn.tap()
                // Should return to Welcome or Sign in screen where Get Started exists
                // Note: The UI Test resets app state on every launch unless token is retained
                let getStarted = app.buttons["Get Started"]
                XCTAssertTrue(getStarted.waitForExistence(timeout: 5.0), "Should be returned to Welcome Screen on successful logout")
            }
        }
    }
}
