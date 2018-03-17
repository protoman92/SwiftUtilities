//
//  TypeTest.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 4/17/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import XCTest
@testable import SwiftUtilities

public final class Object1: NSObject {}
public final class Object2: IsInstanceType {}

public final class TypeTest: XCTestCase {
  public func test_isInstance_shouldSucceed() {
    /// Setup
    let object1 = Object1()
    let object2 = Object2()
    let object3 = "Test"

    // When
    let isInstance1 = object1.isInstance(of: Object1.self)
    let isInstance2 = object2.isInstance(of: Object2.self)
    let isInstance3 = object3.isInstance(of: String.self)

    // Then
    XCTAssertTrue(isInstance1)
    XCTAssertTrue(isInstance2)
    XCTAssertTrue(isInstance3)
  }

  func test_isOfType_shouldSucceed() {
    /// Setup
    let object1 = Object1()
    let object2 = Object2()
    let object3 = "Test"

    // When
    let isType1 = Object1.isType(of: object1)
    let isType2 = Object2.isType(of: object2)
    let isType3 = String.isType(of: object3)

    // Then
    XCTAssertTrue(isType1)
    XCTAssertTrue(isType2)
    XCTAssertTrue(isType3)
  }
}
