//
//  Preconditions.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 2/10/17.
//  Copyright © 2017 Holmusk. All rights reserved.
//

/// Precondition utilities to validate some logic.
public final class Preconditions {
    private static func fatalErrorWithMessage(_ message: Any?) {
        fatalError(String(describing: message))
    }
    
    public static func checkRunningOnMainThread(_ message: Any?) {
        if isInDebugMode() && !Thread.isMainThread {
            fatalErrorWithMessage(message)
        }
    }
    
    public static func checkNotRunningOnMainThread(_ message: Any?) {
        if isInDebugMode() && Thread.isMainThread {
            fatalErrorWithMessage(message)
        }
    }
    
    public static func checkArguments(_ expression: Bool, _ message: Any?) {
        if isInDebugMode() && expression {
            fatalErrorWithMessage(message)
        }
    }
    
    private init() {}
}
