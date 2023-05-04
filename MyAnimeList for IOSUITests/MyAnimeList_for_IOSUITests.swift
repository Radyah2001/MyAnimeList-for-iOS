//
//  MyAnimeList_for_IOSUITests.swift
//  MyAnimeList for IOSUITests
//
//  Created by Haydar Bahr on 20/04/2023.
//

import XCTest

final class MyAnimeList_for_IOSUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testChangeBackgroundColor() throws {
        let app = XCUIApplication()
        app.launch()
        // Tap the "Change Color" button to change the background color
        let changeColorButton = app.buttons["Change Color"]
        changeColorButton.tap()

        // Assert that the background color has changed to Color("Color1")
        let expectedColor = UIColor(named: "Color1")!
        let actualColor = app.windows.firstMatch.value(forKey: "backgroundColor") as! UIColor
        XCTAssertEqual(actualColor, expectedColor)

        // Tap the "Change Color" button again to change the background color back to white
        changeColorButton.tap()

        // Assert that the background color has changed back to white
        let expectedWhite = UIColor.white
        let actualWhite = app.windows.firstMatch.value(forKey: "backgroundColor") as! UIColor
        XCTAssertEqual(actualWhite, expectedWhite)
    }

    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
