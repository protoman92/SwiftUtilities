//
//  ExceptionTest.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/6/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import XCTest
@testable import SwiftUtilities

public final class ExceptionTest: XCTestCase {
    public func test_exceptionCreation_shouldSucceed() {
        /// Setup & When
        let e1 = Exception("Exception!")
        let e2 = Exception(e1)
        let e3 = Exception(e2.cause)
        
        // Then
        for e in [e1, e2, e3] {
            print(e, e.cause)
        }
    }
}
