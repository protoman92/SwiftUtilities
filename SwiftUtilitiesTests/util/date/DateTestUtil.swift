//
//  DateTestUtil.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 4/12/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import Foundation

public extension DateComponents {
    
    /// Create a DateComponents from separate components.
    ///
    /// - Parameters:
    ///   - day: The day number.
    ///   - month: The month number.
    ///   - year: The year number.
    ///   - hour: The hour number.
    ///   - minute: The minute number.
    ///   - second: The second number.
    /// - Returns: A DateComponents struct.
    public static func from(day: Int? = nil,
                            month: Int? = nil,
                            year: Int? = nil,
                            hour: Int? = nil,
                            minute: Int? = nil,
                            second: Int? = nil) -> DateComponents {
        var component = DateComponents()
        component.day = day ?? 1
        component.month = month ?? 0
        component.year = year ?? 0
        component.hour = hour ?? 0
        component.minute = minute ?? 0
        component.second = second ?? 0
        return component
    }
    
    /// Get a random DateComponents.
    ///
    /// - Returns: A DateComponents struct.
    public static func random() -> DateComponents {
        return DateComponents.from(day: Int.randomBetween(1, 28),
                                   month: Int.randomBetween(1, 12),
                                   year: Int.randomBetween(2000, 2016),
                                   hour: Int.randomBetween(0, 59),
                                   minute: Int.randomBetween(0, 59),
                                   second: Int.randomBetween(0, 59))
    }
}

public extension Calendar.Component {
    
    /// Get a random Calendar.Component.
    ///
    /// - Returns: A Calendar.Component instance.
    public static func random() -> Calendar.Component {
        let components: Set<Calendar.Component> = [.minute,
                                                   .hour,
                                                   .day,
                                                   .month,
                                                   .year,
                                                   .weekday]
        
        let index = Int.randomBetween(0, components.count - 1)
        return components.map({$0})[index]
    }
}

public extension Date {
    
    /// Get a random Date instance.
    ///
    /// - Returns: A Date instance.
    public static func random() -> Date? {
        let components = DateComponents.random()
        return Calendar(identifier: .gregorian).date(from: components)
    }
}
