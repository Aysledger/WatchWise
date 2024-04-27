//
//  MovieAppUITests.swift
//  MovieAppUITests
//
//  Created by Aytan Gurbanova on 12.04.2024.
//

import XCTest
var app: XCUIApplication?

class MovieUITests: XCTestCase {
  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
    app = XCUIApplication()
    app?.launch()
  }

  func testStartNowButton() throws {
    // given
    XCTAssertTrue(((app?.buttons["Start Now"].exists) != nil))
    // when
    app?.buttons["Start Now"].tap()
    // then
    XCTAssertTrue(((app?.tabBars.firstMatch.exists) != nil))
  }

  func testTrendingMoviesTextExists() {
    // Given
    XCUIApplication().buttons["Start Now"].tap()

    // When
    let trendingMoviesText = app?.staticTexts["Trending Movies"]
    let trendingSeriesText = app?.staticTexts["Trending Series"]

    // Then
    XCTAssertTrue(((trendingMoviesText?.exists) != nil))
    XCTAssertTrue(((trendingSeriesText?.exists) != nil))
  }

  func testMovieList() throws {
    app?.buttons["Start Now"].tap()

    let searchField = app?.searchFields["Search"]
    searchField?.tap()

    searchField?.typeText("Break")

    app?.buttons["Search"].tap()

    XCTAssertTrue(((app?.staticTexts["Trending Movies"].exists) != nil))
  }
}
