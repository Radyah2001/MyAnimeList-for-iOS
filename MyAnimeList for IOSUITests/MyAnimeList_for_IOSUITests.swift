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

    
    func testNavigateToSearchViewAndGoBack() throws {
            // Launch the app
            let app = XCUIApplication()
            app.launch()

            // Tap on the search button (the magnifying glass icon)
            app.buttons["Search"].tap()

            // Verify that the search view is displayed
            XCTAssertTrue(app.navigationBars["Anime Search"].exists)

            // Go back to the main view
            app.navigationBars["Anime Search"].buttons["Home"].tap()

            // Verify that the main view is displayed
            XCTAssertTrue(app.navigationBars["Home"].exists)
        }
    
    func testSearchForDragonBallAndSelectFirstResult() {
        // Launch the app
        let app = XCUIApplication()
        app.launch()

        // Tap on the search button (the magnifying glass icon)
        app.buttons["Search"].tap()

        // Verify that the search view is displayed
        XCTAssertTrue(app.navigationBars["Anime Search"].exists)

        // Type "Dragon Ball" into the search field and press enter
        let searchField = app.textFields.firstMatch
        searchField.tap()
        searchField.typeText("Dragon Ball")
        searchField.typeText("\n")

        // Wait for the search results to load
        let firstResultCell = app.cells.element(boundBy: 0)
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: firstResultCell, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)

        // Tap on the first result
        firstResultCell.tap()

    }
    func testProfileButtonTap() throws {
        let app = XCUIApplication()
        app.launch()

        let profileButton = app.buttons["person"].firstMatch
        XCTAssertTrue(profileButton.waitForExistence(timeout: 5))
        profileButton.tap()

        // Check if the correct view is displayed (profile view or authorization view)
        let loggedIn = app.staticTexts["Profile"].firstMatch.exists
        let notLoggedIn = app.staticTexts["Home"].firstMatch.exists

        XCTAssertTrue(loggedIn || notLoggedIn)
    }
    
    func testChangeColorButtonTap() throws {
        let app = XCUIApplication()
        app.launch()

        let changeColorButton = app.buttons["changeColorButton"].firstMatch
        XCTAssertTrue(changeColorButton.waitForExistence(timeout: 5))

        // Check the initial background color
        let whiteBackground = app.otherElements["whiteBackground"].firstMatch
        XCTAssertTrue(whiteBackground.waitForExistence(timeout: 5))

        // Tap the "Change Color" button
        changeColorButton.tap()

        // Check if the background color has changed
        let color1Background = app.otherElements["color1Background"].firstMatch
        XCTAssertTrue(color1Background.waitForExistence(timeout: 5))

        // Tap the "Change Color" button again
        changeColorButton.tap()

        // Check if the background color has changed back to white
        XCTAssertTrue(whiteBackground.waitForExistence(timeout: 5))
    }
    
    func testAnimeDetailViewLoadingAndDataDisplay() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Tap on the search button (the magnifying glass icon)
        app.buttons["Search"].tap()

        // Verify that the search view is displayed
        XCTAssertTrue(app.navigationBars["Anime Search"].exists)

        // Type "Dragon Ball" into the search field and press enter
        let searchField = app.textFields.firstMatch
        searchField.tap()
        searchField.typeText("Dragon Ball")
        searchField.typeText("\n")

        // Wait for the search results to load
        let firstResultCell = app.cells.element(boundBy: 0)
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: firstResultCell, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)

        // Tap on the first result
        firstResultCell.tap()



        // Check if the anime details are displayed, e.g., by verifying if the average score is displayed
        let averageScoreLabel = app.staticTexts["Average score"].firstMatch
        XCTAssertTrue(averageScoreLabel.waitForExistence(timeout: 5))
    }





}
