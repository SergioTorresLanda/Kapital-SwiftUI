//
//  SomeAppswiftUIUITests.swift
//  SomeAppswiftUIUITests
//
//  Created by Sergio Torres Landa González on 23/05/25.
//

import XCTest

final class SomeAppswiftUIUITests: XCTestCase {

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["-resetSwiftData"] // Custom launch argument
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddAmiiboToFavoritesAndVerifyInFavoritesView() throws {
        let app = XCUIApplication()
        app.launch()

        let amiibosTitle = app.staticTexts["Amiibos:"]
        XCTAssertTrue(amiibosTitle.waitForExistence(timeout: 10), "Amiibos list should load.")

        let firstAmiiboCard = app.cells.firstMatch 
        // Or app.staticTexts["Name - Series"].firstMatch
        XCTAssertTrue(firstAmiiboCard.waitForExistence(timeout: 5), "First Amiibo card should exist.")
        
        // Get the name of the first amiibo to verify later
        let amiiboName = firstAmiiboCard.staticTexts.firstMatch.label
        XCTAssertFalse(amiiboName.isEmpty, "Amiibo name should be present")

        // 3. Find and tap the favorite heart button on the first Amiibo card
        let heartButton = firstAmiiboCard.buttons["heart.fill"] // Assuming SF Symbol name as accessibility ID
        XCTAssertTrue(heartButton.exists, "Heart button should exist on the first card.")
        heartButton.tap()

        // 4. Navigate to the Favorites View
        let favoritosButton = app.buttons["Favoritos"] // Assuming your ButtonView has this accessibility label
        XCTAssertTrue(favoritosButton.exists, "Favoritos button should exist.")
        favoritosButton.tap()

        // 5. Verify that the Favorites View loads and contains the favorited Amiibo
        let favoritesTitle = app.staticTexts["Favoritos:"]
        XCTAssertTrue(favoritesTitle.waitForExistence(timeout: 5), "Favorites view should load.")
        
        // Check if the favorited amiibo's name is present in the favorites list
        let favoritedAmiiboText = app.staticTexts["\(amiiboName) -"] // Partial match, adjust if needed
        XCTAssertTrue(favoritedAmiiboText.waitForExistence(timeout: 5), "Favorited Amiibo should appear in Favorites list.")
        
        // (Optional) Go back to main list and verify heart is still red
        app.navigationBars.buttons.element(boundBy: 0).tap() // Tap back button
        // Re-check the heart button color on the first amiibo card in the main list
        XCTAssertTrue(heartButton.exists, "Heart button should still exist on the first card.")
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
