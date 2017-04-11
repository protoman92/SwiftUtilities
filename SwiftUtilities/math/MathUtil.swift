//
//  MathUtil.swift
//  Heartland Chefs
//
//  Created by Hai Pham on 1/13/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import Foundation
import UIKit

protocol Summable {
    static var Zero: Self { get }
    
    static func +(lhs: Self, rhs: Self) -> Self
}

extension Array where Element: Summable {
    var sum: Element {
        return self.reduce(Element.Zero, +)
    }
}

extension Int: Summable {
    static var Zero: Int { return 0 }
}

extension Double: Summable {
    static var Zero: Double { return 0.0 }
}

extension Double: CustomComparisonProtocol {
    func equals(object: Double?) -> Bool {
        return object == self
    }
}

extension Double {
    
    /// Convert the current Double value to radians.
    var radians: Double {
        return self * Double.pi / 180
    }
}

extension CGFloat {
    
    /// Convert the current CGFloat value to radians.
    var radians: CGFloat {
        return CGFloat((Double(self).radians))
    }
}
