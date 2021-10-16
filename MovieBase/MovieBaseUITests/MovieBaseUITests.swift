// MovieBaseUITests.swift
// Copyright © RoadMap. All rights reserved.

import XCTest
/// XCTest-
class MovieBaseUITests: XCTestCase {
    var application: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        application = XCUIApplication()
        application.launch()
    }

    override func tearDownWithError() throws {}

    func testFilmsTableView() {
        let filmTableView = application.tables["FilmTableView"]
        XCTAssertTrue(filmTableView.exists)
        XCTAssertTrue(filmTableView.isEnabled)
        XCTAssertTrue(filmTableView.isHittable)
        XCTAssertFalse(filmTableView.isSelected)
        filmTableView.swipeUp()
        filmTableView.swipeDown()
    }

    func testCellMovieViewController() {
        let movieTableView = application.tables["FilmTableView"]
        let cell = movieTableView.cells["FilmCell"]

        XCTAssertTrue(cell.exists)
        XCTAssertTrue(cell.firstMatch.isHittable)
        cell.firstMatch.tap()
    }
}
