//
//  Booleans.swift
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
    
    /// Return true for any object.
    ///
    /// - Parameter value: Any object.
    /// - Returns: A Bool value.
    public static func toTrue(_ value: Any) -> Bool {
        return true
    }
    
    /// Return false for any object.
    ///
    /// - Parameter value: Any object.
    /// - Returns: A Bool value.
    public static func toFalse(_ value: Any) -> Bool {
        return false
    }
    
    /// Reverse a Bool value.
    ///
    /// - Parameter value: A Bool value.
    /// - Returns: A Bool value.
    public static func reverse(_ value: Bool) -> Bool {
        return !value
    }
    
    /// Create a random Bool value.
    ///
    /// - Returns: A Bool value.
    public static func random() -> Bool {
        return arc4random_uniform(2) == 0
    }
}
