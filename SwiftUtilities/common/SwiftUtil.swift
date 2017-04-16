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

/// Print only in debug mode.
///
/// - Parameter args: Items to be printed.
public func debugPrint(_ args: Any...) {
    if isInDebugMode() {
        print(args)
    }
}

/// Print one item only in debug mode.
///
/// - Parameter item: The item to be printed.
public func debugPrint(_ item: Any) {
    if isInDebugMode() {
        print(item)
    }
}
