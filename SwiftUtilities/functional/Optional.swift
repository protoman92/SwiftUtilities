//
//  Optional.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 24/9/17.
//  Copyright © 2017 Holmusk. All rights reserved.
//

/// Classes that implement this protocol should be convertible to an Optional.
public protocol OptionalConvertibleType {
    associatedtype Value
    
    func asOptional() -> Optional<Value>
}

/// Classes that implement this protocol must be expressible as an Optional.
public protocol OptionalType: OptionalConvertibleType {
    static func just(_ value: Value) -> Optional<Value>
    
    static func nothing() -> Optional<Value>
    
    var value: Value? { get }
}

public extension OptionalType {
    public func isSome() -> Bool {
        return value != nil
    }
    
    public func isNothing() -> Bool {
        return !isSome()
    }
    
    /// Return the current Optional, or a backup Optional is the former is empty.
    ///
    /// - Parameter backup: An Optional instance.
    /// - Returns: An Optional instance.
    public func getOrElse(_ backup: Optional<Value>) -> Optional<Value> {
        return isSome() ? self.asOptional() : backup
    }
    
    /// Return the current Optional, or a backup Optional is the former is empty.
    ///
    /// - Parameter backup: An OptionalConvertibleType instance.
    /// - Returns: An Optional instance.
    public func getOrElse<OC>(_ backup: OC) -> Optional<Value> where
        OC: OptionalConvertibleType, OC.Value == Value
    {
        return getOrElse(backup.asOptional())
    }
}

extension Optional: OptionalType {
    public typealias Value = Wrapped
    
    public static func just(_ value: Value) -> Optional<Value> {
        return .some(value)
    }
    
    public static func nothing() -> Optional<Value> {
        return .none
    }
    
    public func asOptional() -> Optional<Wrapped> {
        return self
    }
    
    public var value: Value? {
        switch self {
        case .some(let value): return value
        default: return nil
        }
    }
    
    /// Filter the inner value using a selector and return nothing if it does
    /// not pass the predicate.
    ///
    /// - Parameter selector: Selector function.
    /// - Returns: An Optional instance.
    public func filter(selector: (Val) throws -> Bool) -> Optional<Val> {
        return asTry().filter(selector, "").asOptional()
    }
}
