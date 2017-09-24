//
//  Optional.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 24/9/17.
//  Copyright © 2017 Holmusk. All rights reserved.
//

/// Classes that implement this protocol must be expressible as an Optional.
public protocol OptionalType {
    associatedtype Value
    
    static func just(_ value: Value) -> Self
    
    static func nothing() -> Self
    
    var value: Value? { get }
}

extension Optional: OptionalType {
    public typealias Value = Wrapped
    
    public static func just(_ value: Value) -> Optional<Value> {
        return .some(value)
    }
    
    public static func nothing() -> Optional<Value> {
        return .none
    }
    
    public var value: Value? {
        switch self {
        case .some(let value): return value
        default: return nil
        }
    }
}
