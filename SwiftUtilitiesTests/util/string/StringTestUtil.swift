//
//  StringTestUtil.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 4/12/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

public extension Character {
    
    /// Create a random Character. This is useful for creating random Strings.
    ///
    /// - Returns: A Character.
    public static func random() -> Character {
        let startingValue = Int(("a" as UnicodeScalar).value)
        let count = Int.randomBetween(0, 51)
        return Character(UnicodeScalar(count + startingValue)!)
    }
}

public extension String {
    
    /// Create a random String.
    ///
    /// - Parameter length: The length of the String to be created.
    /// - Returns: A String value.
    public static func random(withLength length: Int) -> String {
        return String((0..<length).map({_ in Character.random()}))
    }
}
