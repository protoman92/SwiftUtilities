//
//  RxTestUtil.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 4/23/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import RxCocoa
import RxTest
import RxBlocking

public extension TestableObserver {
    
    /// Get all next events.
    ///
    /// - Returns: An Array of ElementType.
    public func nextElements() -> [ElementType] {
        return events.flatMap({$0.value.element})
    }
    
    /// Check if there is any next element.
    ///
    /// - Returns: A Bool value.
    public func hasNextElements() -> Bool {
        return nextElements().isNotEmpty
    }
    
    /// Check if there are no next elements.
    ///
    /// - Returns: A Bool value.
    public func hasNoNextElements() -> Bool {
        return !hasNextElements()
    }
    
    /// Get error in case there is an error event.
    ///
    /// - Returns: An Error instance.
    public func errorElement() -> Error? {
        return events.flatMap({$0.value.error}).first
    }
    
    /// Check if there is an error.
    ///
    /// - Returns: A Bool value.
    public func hasError() -> Bool {
        return errorElement() != nil
    }
    
    /// Check if there is no error.
    ///
    /// - Returns: A Bool value.
    public func hasNoError() -> Bool {
        return !hasError()
    }
    
    /// Get completed event.
    ///
    /// - Returns: A Recorded instance.
    public func completedEvent() -> Recorded<Event<ElementType>>? {
        return events.filter({$0.value.isCompleted}).first
    }
    
    /// Check if there is a completed event.
    ///
    /// - Returns: A Bool value.
    public func hasCompleted() -> Bool {
        return completedEvent()
    }
    
    /// Check if there is no completed event.
    ///
    /// - Returns: A Bool value.
    public func hasNotCompleted() -> Bool {
        return !hasCompleted()
    }
}
