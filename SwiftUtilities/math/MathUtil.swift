//
//  MathUtil.swift
//  Heartland Chefs
//
//  Created by Hai Pham on 1/13/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import Foundation
import UIKit

public protocol Summable {
    static var Zero: Self { get }
    
    static func +(lhs: Self, rhs: Self) -> Self
}

public extension Array where Element: Summable {
    public var sum: Element {
        return self.reduce(Element.Zero, +)
    }
}

extension Int: Summable {
    public static var Zero: Int { return 0 }
}

extension Double: Summable {
    public static var Zero: Double { return 0.0 }
}

extension Double: CustomComparisonProtocol {
    public func equals(object: Double?) -> Bool {
        return object == self
    }
}

public extension Double {
    
    /// Convert the current Double value to radians.
    public var radians: Double {
        return self * Double.pi / 180
    }
}

public extension CGFloat {
    
    /// Convert the current CGFloat value to radians.
    public var radians: CGFloat {
        return CGFloat((Double(self).radians))
    }
}

public extension Int {
    
    /// Check if an Int is even. This is convenient for closure checks.
    ///
    /// - Parameter value: The Int value to be checked.
    /// - Returns: A Bool value.
    public static func isEven(_ value: Int) -> Bool {
        return value.isEven
    }
    
    /// Check if an Int is odd. This is convenient for closure checks.
    ///
    /// - Parameter value: The Int value to be checked.
    /// - Returns: A Bool value.
    public static func isOdd(_ value: Int) -> Bool {
        return value.isOdd
    }
    
    /// Check if the current Int is even.
    public var isEven: Bool {
        return self % 2 == 0
    }
    
    /// Check if the current Int is odd.
    public var isOdd: Bool {
        return !isEven
    }
}
