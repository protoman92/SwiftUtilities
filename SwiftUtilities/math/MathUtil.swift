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
