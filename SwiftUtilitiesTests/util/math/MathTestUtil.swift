//
//  MathTestUtil.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 4/12/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import Foundation

public extension Int {
    
    /// Generate a random Int value, with inclusive lower bound and exclusive
    /// upper bound.
    ///
    /// - Parameters:
    ///   - from: Inclusive lower bound Int value.
    ///   - upTo: Exclusive upper bound Int value.
    /// - Returns: An Int value.
    public static func random(_ from: Int? = nil, _ upTo: Int) -> Int {
        let from = UInt32(from ?? 0)
        return Int(arc4random_uniform(UInt32(upTo) - from) + from)
    }

    /// Generate a random Int value, with inclusive lower bound and inclusive
    /// upper bound.
    ///
    /// - Parameters:
    ///   - from: Inclusive lower bound Int value.
    ///   - endValue: Inclusive upper bound Int value.
    /// - Returns: An Int value.
    public static func randomBetween(_ from: Int? = nil, _ end: Int) -> Int {
        return random(from, end + 1)
    }
}
