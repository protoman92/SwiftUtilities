//
//  CollectionTest.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 4/16/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import XCTest
@testable import SwiftUtilities

public final class CollectionsTest: XCTestCase {
  public func test_arrayRepeat_shouldSucceed() {
    /// Setup
    let times = 10
    let selector: (Int) -> String = {String(describing: $0)}

    /// When
    let array = Array(repeating: selector, for: times)
    let reconverted: [Int] = array.flatMap({Int($0)})

    /// Then
    print(array, reconverted)
    XCTAssertEqual(array.count, times)
    XCTAssertEqual(reconverted, (0..<10).map(eq))
  }

  public func test_arrayAllPredicate_shouldSucceed() {
    /// Setup
    let array = [1, 2, 3, 4, 5]

    /// When
    let allSatisfied = array.all(Int.isEven)

    /// Then
    XCTAssertFalse(allSatisfied)
  }

  public func test_arrayAnyPredicate_shouldSucceed() {
    /// Setup
    let array = [1, 2, 3, 4, 5]

    /// When
    let anySatisfied = array.any(Int.isEven)

    /// Then
    XCTAssertTrue(anySatisfied)
  }

  public func test_dictionaryAllPredicate_shouldSucceed() {
    /// Setup
    let dictionary = [1: 1, 2: 2, 3: 3, 4: 4, 5: 5]

    /// When
    let allSatisfied = dictionary.all({
      $0.key.isEven && $0.value.isEven
    })

    /// Then
    XCTAssertFalse(allSatisfied)
  }

  public func test_dictionaryAnyPredicate_shouldSucceed() {
    /// Setup
    let dictionary = [1: 1, 2: 2, 3: 3, 4: 4, 5: 5]

    /// When
    let anySatisfied = dictionary.any({
      $0.key.isEven && $0.value.isEven
    })

    /// Then
    XCTAssertTrue(anySatisfied)
  }

  public func test_logEach_shouldWork() {
    /// Setup
    let array1 = [1, 2, 3, 4]
    let array2 = [1, 2, 3, 4]

    /// When & Then
    array1.logEach()
    array2.logEach({$0 * 2})
  }

  public func test_sequenceDistinct_shouldWork() {
    /// Setup
    let data = [1, 1, 1, 2, 3, 4, 5, 6, 9, 0]

    /// When & Then
    XCTAssertEqual(data.distinct().count, Set(data).count)
  }

  public func test_addDictionaries_shouldWork() {
    /// Setup
    let dict1 = ["a" : "a", "b" : "b", "c" : "c"]
    let dict2 = ["d" : "d", "e" : "e", "f" : "f"]
    let dict3 = ["g" : "g", "h" : "h", "i" : "i"]

    /// When
    let dict123_1 = dict1.updatingValues(dict2).updatingValues(dict3)
    let dict123_2 = [dict1, dict2, dict3].reduce([:], +)

    /// Then
    XCTAssertTrue(dict123_1.all({dict123_2[$0.key] == $0.value}))
  }
}
