//
//  CartUITests.swift
//  SmartGroceryHubUITests
//
//  Created by AI.
//

import XCTest

class CartUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testCartInteractions() throws {
        let cartTab = app.buttons["Giỏ hàng"]
        
        if cartTab.waitForExistence(timeout: 5.0) {
            cartTab.tap()
            
            // Validate the header is present
            let headerText = app.staticTexts["Giỏ hàng của bạn"]
            XCTAssertTrue(headerText.waitForExistence(timeout: 2.0))
            
            // By default state: Cart is empty or contains items
            if app.buttons["Thanh toán"].exists {
                // Assert it triggers Checkout successfully
                app.buttons["Thanh toán"].tap()
                // Wait for the "Thành công" alert
                let alert = app.alerts["Thành công"]
                XCTAssertTrue(alert.waitForExistence(timeout: 2.0))
                alert.buttons["OK"].tap()
            } else {
                // Default empty state verification
                XCTAssertTrue(app.staticTexts["Giỏ hàng đang trống"].exists)
            }
        }
    }
}
