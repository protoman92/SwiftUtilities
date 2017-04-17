//
//  BooleanTestUtil.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 4/17/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import Foundation

public extension Bool {
    
    /// Create a random Bool value.
    ///
    /// - Returns: A Bool value.
    public static func random() -> Bool {
        return arc4random_uniform(2) == 0
    }
}
