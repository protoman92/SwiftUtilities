//
//  LocalizerType.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 15/12/17.
//  Copyright © 2017 Holmusk. All rights reserved.
//

/// Classes that implement this protocol should be able to localize Strings.
public protocol LocalizerType {
    func localize(_ value: String) -> String
}

public extension LocalizerType {
    
    /// Localize a String based on some format.
    ///
    /// - Parameters:
    ///   - format: A String value.
    ///   - args: Sequence of CVarArg.
    /// - Returns: A String value.
    public func localize<S>(_ format: String, _ args: S) -> String where
        S: Sequence, S.Element == CVarArg
    {
        let localizedFormat = localize(format)
        return String(format: localizedFormat, arguments: args.map({$0}))
    }
    
    /// Localize a String based on some format.
    ///
    /// - Parameters:
    ///   - format: A String value.
    ///   - args: Varargs of CVarArg.
    /// - Returns: A String value.
    public func localize(_ format: String, _ args: CVarArg...) -> String {
        return localize(format, args)
    }
}
