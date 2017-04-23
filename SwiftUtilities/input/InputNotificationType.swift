//
//  InputNotificationType.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 4/23/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

/// Implement this protocol to notify observers of inputs or errors.
public protocol InputNotificationType {
    /// Whether there are input errors.
    var hasErrors: Bool { get }
    
    /// Return either inputs or errors, depending on whether errors are
    /// present.
    var outputs: [String: String] { get }
    
    /// Append an input.
    ///
    /// - Parameters:
    ///   - input: A String value.
    ///   - key: A String value.
    func append(input: String, for key: String)
    
    /// Append an error.
    ///
    /// - Parameters:
    ///   - input: A String value.
    ///   - key: A String value.
    func append(error: String, for key: String)
    
    /// Construct from an Array of InputNotificationComponentType.
    init(from components: [InputNotificationComponentType])
}

/// Implement this protocol to hold notification component for one input.
public protocol InputNotificationComponentType {
    
    /// Whether there is an input error.
    var hasError: Bool { get }
    
    /// The input's identifier.
    var inputKey: String { get }
    
    /// The input value. Depending on whether hasError is true/false, this
    /// can either be an input content or error message.
    var inputValue: String { get }
}
