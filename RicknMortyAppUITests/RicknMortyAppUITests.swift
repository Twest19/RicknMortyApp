//
//  RicknMortyAppUITests.swift
//  RicknMortyAppUITests
//
//  Created by Tim West on 11/30/23.
//

import XCTest

final class RicknMortyAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    

    @MainActor func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        XCUIDevice.shared.orientation = .portrait
        try testEntireAppNavigation(app: app)
    }
    
    
    @MainActor func createScreenshots(app: XCUIApplication) throws {
        // MARK: Test 1: Initial launching of app testing Collection View
        let cellsQuery = app.collectionViews.cells
        let cvCell = cellsQuery.otherElements.containing(.staticText, identifier:"Morty Smith").element
        XCTAssertTrue(cvCell.exists)
        snapshot("Character CollectionView Screen")
        cvCell.tap()
        snapshot("Character Detail Screen")
        
        let doneBTN = app.navigationBars["RicknMortyApp.RMCharacterDetailVC"].buttons["Done"]
        XCTAssertTrue(doneBTN.exists)
        doneBTN.tap()
        
        let episodeTab = app.tabBars["Tab Bar"].buttons["Episode"]
        XCTAssertTrue(episodeTab.exists)
        episodeTab.tap()
        // MARK: Episode Screen Shot Test
        snapshot("Episode TableView Screen")
        let episodeTable = app.tables/*@START_MENU_TOKEN@*/.staticTexts["E02 - Lawnmower Dog"]/*[[".cells.staticTexts[\"E02 - Lawnmower Dog\"]",".staticTexts[\"E02 - Lawnmower Dog\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(episodeTable.exists)
        episodeTable.tap()
        snapshot("Expanded TableView Cell")
        
        let tester = app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"December 9, 2013").staticTexts["View Characters"]/*[[".cells.containing(.staticText, identifier:\"E02 - Lawnmower Dog\")",".buttons[\"View Characters\"].staticTexts[\"View Characters\"]",".staticTexts[\"View Characters\"]",".cells.containing(.staticText, identifier:\"December 9, 2013\")"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(tester.exists)
        tester.tap()
        snapshot("After Tapping View Characters")
    }
    
    
    func testEntireAppNavigation(app: XCUIApplication) throws {
        // MARK: Test 2: Test Tap Cell -> View Characters in modal
        let cellsQuery = app.collectionViews.cells
        var cvCell = cellsQuery.otherElements.containing(.staticText, identifier:"Morty Smith").element
        XCTAssertTrue(cvCell.exists)
        cvCell.tap()

        let getDetailChars = app.scrollViews.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 1).staticTexts["View Characters"]
        XCTAssertTrue(getDetailChars.exists)
        getDetailChars.tap()

        // MARK: Test 3: Test Search after detail view chars tapped
        var searchBTN = app.navigationBars["S01E01 - Pilot"].buttons["Search"]
        XCTAssertTrue(searchBTN.exists)
        searchBTN.tap()

        var searchField = app.navigationBars["S01E01 - Pilot"]/*@START_MENU_TOKEN@*/.searchFields["Search Characters Here..."]/*[[".staticTexts[\"S01E01 - Pilot\"].searchFields[\"Search Characters Here...\"]",".searchFields[\"Search Characters Here...\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        searchField.typeText("Pickle Rick")

        searchBTN = app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(searchBTN.exists)
        searchBTN.tap()

        let firstCell = cellsQuery.otherElements.containing(.staticText, identifier:"Pickle Rick").element
        XCTAssertTrue(firstCell.exists)
        firstCell.tap()

        let doneBTN = app.navigationBars["RicknMortyApp.RMCharacterDetailVC"].buttons["Done"]
        XCTAssertTrue(doneBTN.exists)
        doneBTN.tap()

        searchBTN = app.navigationBars["Pickle Rick"].buttons["Search"]
        XCTAssertTrue(searchBTN.exists)
        searchBTN.tap()

        searchField = app.navigationBars["Pickle Rick"]/*@START_MENU_TOKEN@*/.searchFields["Search Characters Here..."]/*[[".staticTexts[\"Pickle Rick\"].searchFields[\"Search Characters Here...\"]",".searchFields[\"Search Characters Here...\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        searchField.typeText(" ")

        searchBTN = app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(searchBTN.exists)
        searchBTN.tap()

        cvCell = cellsQuery.otherElements.containing(.staticText, identifier:"Morty Smith").element
        XCTAssertTrue(cvCell.exists)
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
