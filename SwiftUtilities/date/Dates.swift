//
//  Dates.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 8/9/16.
//  Copyright © 2016 Swiften. All rights reserved.
//

extension Date: IsInstanceType {}
extension Calendar: IsInstanceType {}
public typealias CalendarUnits = Set<Calendar.Component>

public extension Date {
    
    /// Check if the current Date is earlier than, or at least the same as, 
    /// another Date.
    ///
    /// - Parameter date: The Date to be compared to.
    /// - Returns: A Bool value.
    public func notLaterThan(date: Date) -> Bool {
        return compare(date) != .orderedDescending
    }
    
    /// Check if the current Date is earlier than another Date.
    ///
    /// - Parameter date: The Date to be compared to.
    /// - Returns: A Bool value.
    public func earlierThan(date: Date) -> Bool {
        return compare(date) == .orderedAscending
    }
    
    /// Check if the current Date is later than, or at least the same as, 
    /// another Date.
    ///
    /// - Parameter date: The Date to be compared to.
    /// - Returns: A Bool value.
    public func notEarlierThan(date: Date) -> Bool {
        return compare(date) != .orderedAscending
    }
    
    /// Check if the current Date is later than another Date.
    ///
    /// - Parameter date: The Date to be compared to.
    /// - Returns: A Bool value.
    public func laterThan(date: Date) -> Bool {
        return compare(date) == .orderedDescending
    }
    
    /// Check if the current Date is the same as another Date.
    ///
    /// - Parameter date: The Date to be compared to.
    /// - Returns: A Bool value.
    public func sameAs(date: Date) -> Bool {
        return compare(date) == .orderedSame
    }
}

public extension Calendar {
    
    /// Check if a Date is earlier than or the same as another Date, based on 
    /// the specified
    /// granularity level.
    ///
    /// - Parameters:
    ///   - date: The Date to be compared.
    ///   - ref: The Date to be compared to.
    ///   - granularity: The level of comparison.
    /// - Returns: A Bool value.
    public func notLaterThan(compare date: Date,
                             to ref: Date,
                             granularity: Calendar.Component) -> Bool {
        let result = compare(date, to: ref, toGranularity: granularity)
        return result != .orderedDescending
    }
    
    /// Check if a Date is earlier than another Date, based on the specified 
    /// granularity level.
    ///
    /// - Parameters:
    ///   - date: The Date to be compared.
    ///   - ref: The Date to be compared to.
    ///   - granularity: The level of comparison.
    /// - Returns: A Bool value.
    public func earlierThan(compare date: Date,
                            to ref: Date,
                            granularity: Calendar.Component) -> Bool {
        let result = compare(date, to: ref, toGranularity: granularity)
        return result == .orderedAscending
    }
    
    /// Check if a Date is later than or the same as another Date, based on 
    /// the specified
    /// granularity level.
    ///
    /// - Parameters:
    ///   - date: The Date to be compared.
    ///   - ref: The Date to be compared to.
    ///   - granularity: The level of comparison.
    /// - Returns: A Bool value.
    public func notEarlierThan(compare date: Date,
                               to ref: Date,
                               granularity: Calendar.Component) -> Bool {
        let result = compare(date, to: ref, toGranularity: granularity)
        return result != .orderedAscending
    }
    
    /// Check if a Date is later than another Date, based on the specified 
    /// granularity level.
    ///
    /// - Parameters:
    ///   - date: The Date to be compared.
    ///   - ref: The Date to be compared to.
    ///   - granularity: The level of comparison.
    /// - Returns: A Bool value.
    public func laterThan(compare date: Date,
                          to ref: Date,
                          granularity: Calendar.Component) -> Bool {
        let result = compare(date, to: ref, toGranularity: granularity)
        return result == .orderedDescending
    }
    
    /// Check if a Date is the same as another Date, based on the specified 
    /// granularity level.
    ///
    /// - Parameters:
    ///   - date: The Date to be compared.
    ///   - ref: The Date to be compared to.
    ///   - granularity: The level of comparison.
    /// - Returns: A Bool value.
    public func sameAs(compare date: Date,
                       to ref: Date,
                       granularity: Calendar.Component) -> Bool {
        let result = compare(date, to: ref, toGranularity: granularity)
        return result == .orderedSame
    }
}

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
