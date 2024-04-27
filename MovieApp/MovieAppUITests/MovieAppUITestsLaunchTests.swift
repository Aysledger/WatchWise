//
//  MovieAppUITestsLaunchTests.swift
//  MovieAppUITests
//
//  Created by Aytan Gurbanova on 12.04.2024.
//

import XCTest

final class MovieAppUITestsLaunchTests: XCTestCase {
  override class var runsForEachTargetApplicationUIConfiguration: Bool {
    true
  }

  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  func testLaunch() throws {
    let app = XCUIApplication()
    app.launch()
    XCUIApplication().scrollViews.otherElements.buttons["Start Now"].tap()

    let attachment = XCTAttachment(screenshot: app.screenshot())
    attachment.name = "Launch Screen"
    attachment.lifetime = .keepAlways
    add(attachment)
  }
}
