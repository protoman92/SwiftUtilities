//
//  DateUtil.swift
//  Heartland Chefs
//
//  Created by Hai Pham on 8/9/16.
//  Copyright © 2016 Swiften. All rights reserved.
//

import UIKit

public extension DateComponents {
    
    /// Create a DateComponent from separate components.
    ///
    /// - Parameters:
    ///   - day: The day number.
    ///   - month: The month number.
    ///   - year: The year number.
    ///   - hour: The hour number.
    ///   - minute: The minute number.
    ///   - second: The second number.
    /// - Returns: A DateComponent struct.
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
}

public extension Date {
    
    /// Check if the current Date is earlier than, or at least the same as, 
    /// another Date.
    ///
    /// - Parameter date: The Date to be compared to.
    /// - Returns: A Bool value.
    public func earlierThanOrSameAs(date: Date) -> Bool {
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
    public func laterThanOrSameAs(date: Date) -> Bool {
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
    public func earlierThanOrSameAs(compare date: Date,
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
    public func laterThanOrSameAs(compare date: Date,
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

/// Convenience typealias
public typealias CalendarUnits = Set<Calendar.Component>

public struct DateFormat {
    public static let ddMM = "dd MM"
    public static let ddMMM = "dd MMM"
    public static let ddMMMM = "dd MMMM"
    public static let ddMMMYYYYhhmma = "dd MMM YYYY hh:mm a"
    public static let ddMMMMYYYYhhmma = "dd MMMM YYYY hh:mm a"
    public static let EEddMMYY = "EE, dd-MM-YY"
    public static let EEddMMYYhhmma = "EE, dd-MM-YY hh:mm a"
    public static let EEEEddMMMYYYY = "EEEE, dd MMMM YYYY"
    public static let EEEEddMMMYYYYhhmma = "EEEE, dd MMMM YYYY hh:mm a"
    public static let hhmma = "hh:mm a"
    public static let MMMMYYYY = "MMMM, YYYY"
}
