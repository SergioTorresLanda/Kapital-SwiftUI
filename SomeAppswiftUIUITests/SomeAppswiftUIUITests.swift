//
//  SomeAppswiftUIUITests.swift
//  SomeAppswiftUIUITests
//
//  Created by Sergio Torres Landa González on 23/05/25.
//

import XCTest

final class SomeAppswiftUIUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
            app = XCUIApplication()
            // Launch with arguments para resetear SwiftData (ver la configuracion en SomeAppswiftUIApp.swift)
            app.launchArguments = ["-resetSwiftData", "-uiTest"] // UI test flag generica.
            app.launch()
    }

    override func tearDownWithError() throws {
        app=nil
    }

    func testAddAmiiboToFavoritesAndVerifyInFavoritesView() throws {
        let app = XCUIApplication()
        app.launch()

        let firstAmiiboCard = app.cells.firstMatch 
        XCTAssertTrue(firstAmiiboCard.waitForExistence(timeout: 40), "First Amiibo card should exist.")
        // Obtener el nombre del primer elemento para verificarlo despues.
        let amiiboName = firstAmiiboCard.staticTexts.firstMatch.label
        XCTAssertFalse(amiiboName.isEmpty, "Amiibo name should be present")
        firstAmiiboCard.staticTexts.firstMatch.tap()
        // 4. Navegar a la vista de favoritos..
        // 5. Verificar que la seccion de favoritos contenga el elemento seleccionado.
          let favoritesTitle = app.staticTexts["Favorites Count"] // Se puede usar un accesibility identifier.
          XCTAssertTrue(favoritesTitle.waitForExistence(timeout: 5), "Favorites view should load.")
          // Revisar que el nombre este presente.
          let favoritedAmiiboText = app.staticTexts["\(amiiboName) -"] //Mejor usar un accesibility identifier.
          XCTAssertTrue(favoritedAmiiboText.waitForExistence(timeout: 5), "Favorited Amiibo should appear in Favorites list.")
          
        let favoritosButton = app.buttons["Favoritos"]
        XCTAssertTrue(favoritosButton.exists, "Favoritos button should exist.")
        favoritosButton.tap()
        app.navigationBars.buttons.element(boundBy: 0).tap() // Tap back button
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // Esto mide cuanto tarda en lanzarse la app.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
