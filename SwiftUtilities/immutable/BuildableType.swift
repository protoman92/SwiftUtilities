//
//  BuildableType.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/30/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

/// Classes that implement this protocol must declare a Builder class to
/// construct instances of said classes.
public protocol BuildableType: CloneableType {
    associatedtype Builder
    
    static func builder() -> Builder
}

/// Builders should implement this protocol.
public protocol BuilderType {
    associatedtype Buildable
    
    /// Copy all properties from another Buildable to the one associated with
    /// this Builder.
    ///
    /// - Parameter buildable: A Buildable instance.
    /// - Returns: The current Builder instance.
    func with(buildable: Buildable) -> Self
    
    func build() -> Buildable
}

public extension BuildableType where Builder: BuilderType, Self == Builder.Buildable {

    /// Instead of mutating properties here, we create a new Builder and copy
    /// all properties to the new Buildable instance.
    ///
    /// - Returns: A Builder instance.
    public func cloneBuilder() -> Builder {
        return Self.builder().with(buildable: self)
    }
    
    /// Clone the current object by creating a new one via Builder and copying
    /// all properties.
    ///
    /// - Returns: A Self instance.
    public func clone() -> Self {
        return cloneBuilder().build()
    }
}
