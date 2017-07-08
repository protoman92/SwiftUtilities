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
    public func apply(_ a: A) throws -> B {
        return try f(a)
    }
    
    public func map<B1>(_ g: @escaping (B) throws -> B1) -> Reader<A,B1> {
        return Reader<A,B1>({try g(self.f($0))})
    }
    
    public func flatMap<R,B1>(_ g: @escaping (B) throws -> R) -> Reader<A,B1>
        where R: ReaderConvertibleType, R.A == A, R.B == B1
    {
        return Reader<A,B1>({try g(self.f($0)).asReader().apply($0)})
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
