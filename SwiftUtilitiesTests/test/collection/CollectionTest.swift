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
}
