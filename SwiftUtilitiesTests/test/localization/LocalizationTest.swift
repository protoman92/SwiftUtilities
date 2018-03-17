//
//  LocalizationTest.swift
//  SwiftUtilitiesTests
//
//  Created by Hai Pham on 14/12/17.
//  Copyright © 2017 Holmusk. All rights reserved.
//

import XCTest
@testable import SwiftUtilities

public final class LocalizationTest: XCTestCase {
  fileprivate var bundle: Bundle!
  fileprivate var tables: [String]!
  fileprivate var localizer: LocalizerType!

  override public func setUp() {
    super.setUp()
    bundle = Bundle(for: LocalizationTest.self)
    tables = ["Localizable1", "Localizable2"]

    localizer = Localizer.builder()
      .add(bundle: bundle!)
      .add(bundle: Bundle.main)
      .add(tables: tables!)
      .build()

    continueAfterFailure = false
  }

  public func test_localizeStrings_shouldWorkCorrectly() {
    /// Setup
    let strings = [
      "string1_test1",
      "string1_test2",
      "string2_test1",
      "string2_test2"
    ]

    let wrongString = "wrongString"

    /// When
    for string in strings {
      let localized1 = localizer.localize(string)
      let localized2 = string.localize(bundle, tables)

      /// Then
      XCTAssertNotEqual(string, localized1)
      XCTAssertEqual(localized1, localized2)
    }

    XCTAssertEqual(wrongString.localize(bundle, tables), wrongString)
    XCTAssertEqual(localizer.localize(wrongString), wrongString)
  }

  public func test_localizeWithFormat_shouldWork() {
    /// Setup
    let formatString = "string1_test3"

    /// When
    let localized = localizer.localize(formatString, 1)

    /// Then
    XCTAssertNotEqual(formatString, localized)
    XCTAssertEqual(localized, "This is a test 1 with format")
  }
}
