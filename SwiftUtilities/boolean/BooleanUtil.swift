//
//  BooleanUtil.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 4/14/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import Foundation

extension Bool: IsInstanceType {}

public extension Bool {
    
    /// Check if a Bool value is true. This is convenient for closure checks.
    ///
    /// - Parameter value: The Bool value to be checked.
    /// - Returns: A Bool value.
    public static func isTrue(_ value: Bool) -> Bool {
        return value == true
    }
    
    /// Check if a Bool value is false. This is convenient for closure checks.
    ///
    /// - Parameter value: The Bool value to be checked.
    /// - Returns: A Bool value.
    public static func isFalse(_ value: Bool) -> Bool {
        return value == false;
    }
    
    /// Create a random Bool value.
    ///
    /// - Returns: A Bool value.
    public static func random() -> Bool {
        return arc4random_uniform(2) == 0
    }
}
