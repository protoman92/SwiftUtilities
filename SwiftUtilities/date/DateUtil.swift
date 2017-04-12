//
//  DateUtil.swift
//  Heartland Chefs
//
//  Created by Hai Pham on 8/9/16.
//  Copyright © 2016 Swiften. All rights reserved.
//

import UIKit

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
