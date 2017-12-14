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
    override public func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    public func test_localizeStrings_shouldWorkCorrectly() {
        /// Setup
        let bundle = Bundle(for: LocalizationTest.self)
        
        let tables = ["Localizable1", "Localizable2"]
        
        let strings = [
            "string1_test1",
            "string1_test2",
            "string2_test1",
            "string2_test2"
        ]
        
        let wrongString = "wrongString"
        
        /// When
        for string in strings {
            let localized = string.localize(bundle, tables)
            
            /// Then
            XCTAssertNotEqual(string, localized)
        }
        
        XCTAssertEqual(wrongString.localize(bundle, tables), wrongString)
    }
}
