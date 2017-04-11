//
//  SwiftUtil.swift
//  Heartland Chefs
//
//  Created by Hai Pham on 1/6/16.
//  Copyright © 2016 Swiften. All rights reserved.
//

import UIKit
import Foundation

func readEnvironmentVariable(forKey key: String) -> String? {
    return ProcessInfo.processInfo.environment[key]
}

func readPropertyList(from fileName: String? = nil, key: String) -> Any? {
    let fileName = fileName ?? "Info"
    
    guard
        let path = Bundle.main.path(forResource: fileName, ofType: "plist"),
        let dict = NSDictionary(contentsOfFile: path)
    else {
        return nil
    }
    
    return dict.value(forKey: key)
}

func readPropertyList(from fileName: String? = nil,
                      key: String,
                      action: (Any) -> Void) {
    guard let value = readPropertyList(from: fileName, key: key) else {
        return
    }
    
    action(value)
}

extension NSObject {
    
    /// Check if the current NSObject is an instance of a specified Type.
    ///
    /// - Parameter type: The Type to be checked.
    /// - Returns: A Bool value.
    func isInstance<T>(of type: T.Type) -> Bool {
        return Mirror(reflecting: self).subjectType == type
    }
}
