//
//  Reader.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/8/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import Foundation

/// Use this monad to implement Dependency Injection, where applicable.
public protocol ReaderType {
    associatedtype A
    associatedtype B
    
    var f: (A) throws -> B { get }
}

public extension ReaderType {
    public func apply(_ a: A) throws -> B {
        return try f(a)
    }
    
    public func map<C>(_ g: @escaping (B) throws -> C) -> Reader<A,C> {
        return Reader<A,C>({try g(self.f($0))})
    }
    
    public func flatMap<R,C>(_ g: @escaping (B) throws -> R) -> Reader<A,C>
        where R: ReaderType, R.A == A, R.B == C
    {
        return Reader<A,C>({try g(self.f($0)).apply($0)})
    }
}

public struct Reader<A,B> {
    public let f: (A) throws -> B
    
    public init(_ f: @escaping (A) throws -> B) {
        self.f = f
    }
}

extension Reader: ReaderType {}
