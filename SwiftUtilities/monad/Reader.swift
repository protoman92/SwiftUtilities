//
//  Reader.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/8/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import Foundation

/// Use this to implement Dependency Injection.
public protocol ReaderConvertibleType {
    associatedtype A
    associatedtype B
    
    func asReader() -> Reader<A,B>
}

public protocol ReaderType: ReaderConvertibleType {
    var f: (A) throws -> B { get }
}

public extension ReaderType {
    public func applyOrThrow(_ a: A) throws -> B {
        return try f(a)
    }
    
    public func apply(_ a: A) -> Try<B> {
        return Try({try self.applyOrThrow(a)})
    }
    
    /// Modify the environment with which to execute the function (from A1 to A).
    ///
    /// - Parameter g: Tranform function.
    /// - Returns: A Reader instance.
    public func modify<A1>(_ g: @escaping (A1) -> A) -> Reader<A1,B> {
        return Reader({try self.applyOrThrow(g($0))})
    }
    
    public func map<B1>(_ g: @escaping (B) throws -> B1) -> Reader<A,B1> {
        return Reader<A,B1>({try g(self.f($0))})
    }
    
    public func flatMap<R,B1>(_ g: @escaping (B) throws -> R) -> Reader<A,B1>
        where R: ReaderConvertibleType, R.A == A, R.B == B1
    {
        return Reader<A,B1>({try g(self.f($0)).asReader().applyOrThrow($0)})
    }
    
    public func zip<R,B1,U>(with reader: R, _ g: @escaping (B, B1) throws -> U)
        -> Reader<A,U> where R: ReaderConvertibleType, R.A == A, R.B == B1
    {
        return flatMap({b in reader.asReader().map({try g(b, $0)})})
    }
}

public struct Reader<A,B> {
    public let f: (A) throws -> B
    
    public init(_ f: @escaping (A) throws -> B) {
        self.f = f
    }
}

extension Reader: ReaderType {
    public func asReader() -> Reader<A,B> {
        return self
    }
}
