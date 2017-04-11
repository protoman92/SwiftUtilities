//
//  DateUtil.swift
//  Heartland Chefs
//
//  Created by Hai Pham on 8/9/16.
//  Copyright © 2016 Swiften. All rights reserved.
//

import UIKit

extension DateComponents {
    
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
    static func from(day: Int? = nil,
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

extension Date {
    
    /// Check if the current Date is earlier than, or at least the same as, 
    /// another Date.
    ///
    /// - Parameter date: The Date to be compared to.
    /// - Returns: A Bool value.
    func earlierThanOrSameAs(date: Date) -> Bool {
        return compare(date) != .orderedDescending
    }
    
    /// Check if the current Date is earlier than another Date.
    ///
    /// - Parameter date: The Date to be compared to.
    /// - Returns: A Bool value.
    func earlierThan(date: Date) -> Bool {
        return compare(date) == .orderedAscending
    }
    
    /// Check if the current Date is later than, or at least the same as, 
    /// another Date.
    ///
    /// - Parameter date: The Date to be compared to.
    /// - Returns: A Bool value.
    func laterThanOrSameAs(date: Date) -> Bool {
        return compare(date) != .orderedAscending
    }
    
    /// Check if the current Date is later than another Date.
    ///
    /// - Parameter date: The Date to be compared to.
    /// - Returns: A Bool value.
    func laterThan(date: Date) -> Bool {
        return compare(date) == .orderedDescending
    }
    
    /// Check if the current Date is the same as another Date.
    ///
    /// - Parameter date: The Date to be compared to.
    /// - Returns: A Bool value.
    func sameAs(date: Date) -> Bool {
        return compare(date) == .orderedSame
    }
}

extension Calendar {
    
    /// Check if a Date is earlier than or the same as another Date, based on 
    /// the specified
    /// granularity level.
    ///
    /// - Parameters:
    ///   - date: The Date to be compared.
    ///   - ref: The Date to be compared to.
    ///   - granularity: The level of comparison.
    /// - Returns: A Bool value.
    func earlierThanOrSameAs(compare date: Date,
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
    func earlierThan(compare date: Date,
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
    func laterThanOrSameAs(compare date: Date,
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
    func laterThan(compare date: Date, to ref: Date,
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
    func sameAs(compare date: Date, to ref: Date,
                granularity: Calendar.Component) -> Bool {
        let result = compare(date, to: ref, toGranularity: granularity)
        return result == .orderedSame
    }
}

/// Convenience typealias
typealias CalendarUnits = Set<Calendar.Component>

struct DateFormat {
    static let ddMM = "dd MM"
    static let ddMMM = "dd MMM"
    static let ddMMMM = "dd MMMM"
    static let ddMMMYYYYhhmma = "dd MMM YYYY hh:mm a"
    static let ddMMMMYYYYhhmma = "dd MMMM YYYY hh:mm a"
    static let EEddMMYY = "EE, dd-MM-YY"
    static let EEddMMYYhhmma = "EE, dd-MM-YY hh:mm a"
    static let EEEEddMMMYYYY = "EEEE, dd MMMM YYYY"
    static let EEEEddMMMYYYYhhmma = "EEEE, dd MMMM YYYY hh:mm a"
    static let hhmma = "hh:mm a"
    static let MMMMYYYY = "MMMM, YYYY"
}
