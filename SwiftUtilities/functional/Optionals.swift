//
//  Optionals.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 31/7/17.
//  Copyright © 2017 Holmusk. All rights reserved.
//

extension Optional: TryConvertibleType {
    public typealias Val = Wrapped
    
    /// Convert this Optional into a Try.
    ///
    /// - Returns: A Try instance.
    public func asTry() -> Try<Val> {
        return Try<Val>.from(optional: self)
    }
    
    /// Convert this Optional into a Try.
    ///
    /// - Parameter error: An Error instance.
    /// - Returns: A Try instance.
    public func asTry(error: Error) -> Try<Val> {
        return Try<Val>.from(optional: self, error: error)
    }
    
    /// Convert this Optional into a Try.
    ///
    /// - Parameter error: A String value.
    /// - Returns: A Try instance.
    public func asTry(error: String) -> Try<Val> {
        return asTry(error: Exception(error))
    }
}

public extension Optional {
    
    /// Get the Wrapped value or throw an Error.
    ///
    /// - Parameter error: An Error instance.
    /// - Returns: The Wrapped value.
    /// - Throws: Error if the value is not available.
    public func getOrThrow(error: Error) throws -> Wrapped {
        switch self {
        case .some(let a):
            return a
        
        case .none:
            throw error
        }
    }

    /// Get the Wrapped value or throw an Error.
    ///
    /// - Parameter error: A String value.
    /// - Returns: The Wrapped value.
    /// - Throws: Error if the value is not available.
    public func getOrThrow(error: String) throws -> Wrapped {
        return try getOrThrow(error: Exception(error))
    }
}
