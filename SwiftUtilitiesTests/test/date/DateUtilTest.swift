//
//  DateUtilTest.swift
//  Heartland Chefs
//
//  Created by Hai Pham on 2/11/16.
//  Copyright © 2016 Swiften. All rights reserved.
//

import XCTest

class DateUtilTest: XCTestCase {
    
    /// Test date comparison methods and ensure they work correctly.
    func test_dateComparison_shouldSucceed() {
        // Setup
        let calendar = Calendar.current
        
        /// Test date comparison using parameters. This closure accepts three
        /// arguments, the first being the starting Date, to/from which an 
        /// offset value - the second argument - will be added/subtracted.
        /// The third argument is a Calendar.Component instance that will
        /// be used for granularity comparison.
        let testDateComparison: (Date, Int, Calendar.Component) -> Void = {
            // Setup
            let date = $0.0
            
            // When
            let fDate = calendar.date(byAdding: $0.2, value: -$0.1, to: $0.0)!
            let sDate = calendar.date(byAdding: $0.2, value: $0.1, to: $0.0)!
            
            // Then
            
            /// Comparing from the Date instance itself.
            XCTAssertTrue(date.sameAs(date: date))
            XCTAssertTrue(date.notLaterThan(date: date))
            XCTAssertTrue(date.notEarlierThan(date: date))
            XCTAssertTrue(date.laterThan(date: fDate))
            XCTAssertTrue(date.notEarlierThan(date: fDate))
            XCTAssertTrue(date.earlierThan(date: sDate))
            XCTAssertTrue(date.notLaterThan(date: sDate))
            
            /// Comparing using a Calendar instance.
            XCTAssertTrue(calendar.notLaterThan(compare: date,
                                                to: date,
                                                granularity: $0.2))
            
            XCTAssertTrue(calendar.notEarlierThan(compare: date,
                                                  to: date,
                                                  granularity: $0.2))
            
            XCTAssertTrue(calendar.notEarlierThan(compare: date,
                                                  to: fDate,
                                                  granularity: $0.2))
            
            XCTAssertTrue(calendar.notLaterThan(compare: date,
                                                to: sDate,
                                                granularity: $0.2))
            
            XCTAssertTrue(calendar.laterThan(compare: date,
                                             to: fDate,
                                             granularity: $0.2))
            
            XCTAssertTrue(calendar.notLaterThan(compare: date,
                                                to: sDate,
                                                granularity: $0.2))
        }
        
        // When
        for i in 1...1000 {
            let dateComponents = DateComponents.random()
            let date = calendar.date(from: dateComponents)!
            let offset = Int.randomBetween(1, i)
            let calendarComponent = Calendar.Component.random()
            testDateComparison(date, offset, calendarComponent)
        }
    }
    
    /// Verify that DateFormat works.
    func test_dateConversion_shouldSucceed() {
        let millis: Double = 1478372157
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.EEEEddMMMYYYYhhmma.rawValue
        print(formatter.string(from: Date(timeIntervalSince1970: millis)))
    }
}
