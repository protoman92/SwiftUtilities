//
//  TryTest.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/8/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import XCTest
@testable import SwiftUtilities

public final class TryTest: XCTestCase {
    public func test_tryMonad_shouldWork() {
        // Setup
        let t1 = Try<Int>({ throw Exception("Error1") })
        let t2 = Try<Int>({1})
        
        // When & Then
        XCTAssertEqual(t1.map({Double($0 * 2)}).value, nil)
        XCTAssertEqual(t2.flatMap({a in Try({a})}).value, nil)
        XCTAssertEqual(t1.map({Double($0 * 3)}).value, 3)
        XCTAssertEqual(t2.flatMap({a in Try({a})}).value, 1)
    }
    
    public func test_tryToEither_shouldWork() {
        // Setup
        let t1 = Try<Int>({ throw Exception("Error1") })
        let t2 = Try<Int>({1})
        let e1 = t1.asEither()
        let e2 = t2.asEither()
        
        // When & Then
        XCTAssertTrue(e1.isLeft)
        XCTAssertEqual(e1.left!.localizedDescription, "Error1")
        XCTAssertTrue(e2.isRight)
        XCTAssertEqual(e2.right, 1)
    }
}
