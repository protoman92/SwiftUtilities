//
//  ReaderTest.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/8/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import XCTest
@testable import SwiftUtilities

public final class ReaderTest: XCTestCase {
    public func test_readerMonad_shouldWorkWithDifferentInjection() {
        // Setup
        let r1 = Reader<Int,Int>({$0 * 2})
        let r2 = Reader<Int,String>({$0.description})
        
        do {
            // When & Then
            XCTAssertEqual(try r1.apply(1), 2)
            XCTAssertEqual(try r1.apply(2), 4)
            XCTAssertEqual(try r2.apply(1), "1")
            XCTAssertEqual(try r2.apply(2), "2")
            XCTAssertEqual(try r2.map({Int($0)}).apply(2), 2)
            XCTAssertEqual(try r1.flatMap({i in Reader<Int,Int>({$0 * i})}).apply(2), 8)
        }
    }
}
