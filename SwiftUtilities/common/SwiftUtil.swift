//
//  SwiftUtil.swift
//  Heartland Chefs
//
//  Created by Hai Pham on 1/6/16.
//  Copyright © 2016 Swiften. All rights reserved.
//

import UIKit
import Foundation

/// Read an environment variable.
///
/// - Parameter key: The variable's key identifier.
/// - Returns: An optional String value.
public func readEnvironmentVariable(forKey key: String) -> String? {
    return ProcessInfo.processInfo.environment[key]
}

/// Read a property from an embedded property list. Defaults to 'Info.plist'.
///
/// - Parameters:
///   - fileName: An optional file name.
///   - key: The property's key identifier.
/// - Returns: An optional Any value.
public func readPropertyList(from fileName: String? = nil,
                             key: String) -> Any? {
    let fileName = fileName ?? "Info"
    
    guard
        let path = Bundle.main.path(forResource: fileName, ofType: "plist"),
        let dict = NSDictionary(contentsOfFile: path)
    else {
        return nil
    }
    
    return dict.value(forKey: key)
}

public extension NSObject {
    
    /// Check if the current NSObject is an instance of a specified Type.
    ///
    /// - Parameter type: The Type to be checked.
    /// - Returns: A Bool value.
    func isInstance<T>(of type: T.Type) -> Bool {
        return Mirror(reflecting: self).subjectType == type
    }
}
