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
    
    /// Zip a Sequence of OptionalConvertibleType with a resultSelector.
    ///
    /// - Parameters:
    ///   - optionals: A Sequence of OptionalConvertibleType.
    ///   - resultSelector: Selector function.
    /// - Returns: An Optional instance.
    public static func zip<W1,W2,OC,S>(_ optionals: S,
                                       _ resultSelector: ([W1]) throws -> W2)
        -> Optional<W2> where
        OC: OptionalConvertibleType, OC.Value == W1,
        S: Sequence, S.Element == OC
    {
        let tries = optionals.map({$0.asOptional().asTry()})
        return Try<W2>.zip(tries, resultSelector).value
    }
    
    /// Zip a Sequence of OptionalConvertibleType with a resultSelector.
    ///
    /// - Parameters:
    ///   - resultSelector: Selector function.
    ///   - optionals: Varargs of OptionalConvertibleType.
    /// - Returns: An Optional instance.
    public static func zip<W1,W2,OC>(_ resultSelector: ([W1]) throws -> W2,
                                     _ optionals: OC...) -> Optional<W2> where
        OC: OptionalConvertibleType, OC.Value == W1
    {
        return zip(optionals, resultSelector)
    }
    
    /// Get the wrapped value, or a default value if it is not available.
    ///
    /// - Parameter value: A Wrapped instance.
    /// - Returns: A Wrapped instance.
    public func getOrElse(_ value: Wrapped) -> Wrapped {
        switch self {
        case .some(let a): return a
        case .none: return value
        }
    }
    
    /// Get the Wrapped value or throw an Error.
    ///
    /// - Parameter error: An Error instance.
    /// - Returns: The Wrapped value.
    /// - Throws: Error if the value is not available.
    public func getOrThrow(error: Error) throws -> Wrapped {
        switch self {
        case .some(let a): return a
        case .none: throw error
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
    
    /// Zip with another Optional with a selector function.
    ///
    /// - Parameters:
    ///   - optional: An OptionalConvertibleType instance.
    ///   - resultSelector: Selector function.
    /// - Returns: An Optional instance.
    public func zipWith<W2,W3,OC>(_ optional: OC,
                                  _ resultSelector: (Wrapped, W2) throws -> W3)
        -> Optional<W3> where OC: OptionalConvertibleType, OC.Value == W2
    {
        return asTry().zipWith(optional.asOptional(), resultSelector).value
    }
}
