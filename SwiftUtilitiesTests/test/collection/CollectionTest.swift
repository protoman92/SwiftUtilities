//
//  CollectionTest.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 4/16/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import XCTest

class CustomComparisonCollectionTest: XCTestCase {
    func test_arrayAddUniqueContents_shouldSucceed() {
        // Setup
        var array1 = [1, 2, 3]
        let array2 = [1, 3, 5]
        
        // When
        array1.append(uniqueContentsOf: array2)
        
        // Then
        let set = Set(array1)
        XCTAssertEqual(array1.count, set.count)
    }
    
    func test_arrayContains_shouldSucceed() {
        // Setup
        let array1 = [1, 2, 3]
        
        // When
        let contains = array1.contains(element: 1)
        
        // Then
        XCTAssertTrue(contains)
    }
    
    func test_arrayRepeat_shouldSucceed() {
        // Setup
        let times = 10
        let selector: (Int) -> String = {String(describing: $0)}
        
        // When
        let array = Array(repeating: selector, for: times)
        let reconverted: [Int] = array.flatMap({Int($0)})
        
        // Then
        print(array, reconverted)
        XCTAssertEqual(array.count, times)
        XCTAssertEqual(reconverted, (0..<10).map(eq))
    }
    
    func test_arrayAllPredicate_shouldSucceed() {
        // Setup
        let array = [1, 2, 3, 4, 5]
        
        // When
        let allSatisfied = array.all(satisfying: Int.isEven)
        
        // Then
        XCTAssertFalse(allSatisfied)
    }
    
    func test_arrayAnyPredicate_shouldSucceed() {
        // Setup
        let array = [1, 2, 3, 4, 5]
        
        // When
        let anySatisfied = array.any(satisfying: Int.isEven)
        
        // Then
        XCTAssertTrue(anySatisfied)
    }
    
    func test_dictionaryAllPredicate_shouldSucceed() {
        // Setup
        let dictionary = [1: 1, 2: 2, 3: 3, 4: 4, 5: 5]
        
        // When
        let allSatisfied = dictionary.all(satisfying: {
            $0.key.isEven && $0.value.isEven
        })
        
        // Then
        XCTAssertFalse(allSatisfied)
    }
    
    func test_dictionaryAnyPredicate_shouldSucceed() {
        // Setup
        let dictionary = [1: 1, 2: 2, 3: 3, 4: 4, 5: 5]
        
        // When
        let anySatisfied = dictionary.any(satisfying: {
            $0.key.isEven && $0.value.isEven
        })
        
        // Then
        XCTAssertTrue(anySatisfied)
    }
}
