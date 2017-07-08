//
//  EitherTest.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/8/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import XCTest
@testable import SwiftUtilities

public final class EitherTest: XCTestCase {
    public func test_eitherMonad_shouldWork() {
        // Setup
        let e1 = Either<Int,Double>.left(1)
        let e2 = Either<Int,Double>.right(2)
        
        // When & Then
        XCTAssertEqual(e1.projection.left.map(Double.init).left, 1)
        XCTAssertEqual(e1.projection.right.map(Int.init).right, nil)
        XCTAssertEqual(e2.projection.left.map(Double.init).left, nil)
        XCTAssertEqual(e2.projection.right.map(Int.init).right, 2)
    }
    
    public func test_eitherMonadWithErrorLeft_shouldWork() {
        // Setup
        let e1 = ErrorEither<Int>.left(Exception("Error 1"))
        let e2 = Either<Exception,Int>.left(Exception("Error 2"))
        let e3 = ErrorEither<Int>.right(1)
        
        // When & Then
        XCTAssertThrowsError(try e1.rightOrThrow())
        XCTAssertThrowsError(try e2.rightOrThrow(), "Error 2")
        XCTAssertEqual(try e3.rightOrThrow(), 1)
    }
}
