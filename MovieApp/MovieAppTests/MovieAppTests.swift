//
//  MovieAppTests.swift
//  MovieAppTests
//
//  Created by Aytan Gurbanova on 12.04.2024.
//

import XCTest
@testable import MovieApp

class MovieDiscoverViewModelTests: XCTestCase {
  var sut: URLSession?

  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = URLSession(configuration: .default)
  }

  override func tearDownWithError() throws {
    sut = nil
    try super.tearDownWithError()
  }

  func testValidApiCallGetsHTTPStatusCode200() throws {
    guard let testPlistPath = Bundle.main.url(forResource: "TMDB-info", withExtension: "plist"),
      let testPlist = NSDictionary(contentsOf: testPlistPath),
      let apiKey = testPlist["API_KEY"] as? String else {
      fatalError("Couldn't find or read 'TMDB-info-Test.plist'.")
    }

    let urlString = "https://api.themoviedb.org/3/trending/movie/day?api_key=\(apiKey)"
    guard let url = URL(string: urlString) else { return }

    let promise = expectation(description: "Status code: 200")

    let dataTask = sut?.dataTask(with: url) { _, response, error in
      if let error {
        XCTFail("Error: \(error.localizedDescription)")
        return
      } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
        if statusCode == 200 {
          promise.fulfill()
        } else {
          XCTFail("Status code: \(statusCode)")
        }
      }
    }

    dataTask?.resume()

    wait(for: [promise], timeout: 5)
  }

  func testAddToFavorites() {
    let watchlist = WatchListModel()
    let movie = WatchableItem(
      adult: false,
      title: "Test",
      name: nil,
      backdropPath: nil,
      poster: nil,
      voteAvg: 8,
      overview: "some text",
      isFavorite: false)

    watchlist.addToFavorites(movie: movie)

    XCTAssertTrue(
      watchlist.watchlist.contains { $0.id == movie.id && ($0.isFavorite != nil) }, "Movie added to favorites successfully")
  }
}

class WatchListModelTests: XCTestCase {
  var watchlistModel: WatchListModel?

  override func setUp() {
    super.setUp()
    watchlistModel = WatchListModel()
  }

  override func tearDown() {
    watchlistModel = nil
    super.tearDown()
  }

  func testLoadFavorites() {
    // Given
    let movie = WatchableItem(
      id: 123,
      adult: false,
      title: "Test Movie",
      name: nil,
      backdropPath: nil,
      poster: nil,
      voteAvg: 7.5,
      overview: "Test Overview",
      isFavorite: true)
    guard let jsonData = try? JSONEncoder().encode([movie]) else { return }
    let documentsDirectory = FileManager.documentsDirectoryURL
    let fileURL = documentsDirectory.appendingPathComponent("watchlist.json")
    try? jsonData.write(to: fileURL)

    // When
    watchlistModel?.loadFavorites()

    // Then
    XCTAssertTrue(((watchlistModel?.watchlist.contains { $0.id == movie.id }) != nil))
  }
}
