//
//  Reader.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/8/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import Foundation

public struct Reader<A,B> {
    fileprivate let f: (A) throws -> B
    
    public init(_ f: @escaping (A) throws -> B) {
        self.f = f
    }
    
    public func apply(_ a: A) throws -> B {
        return try f(a)
    }
    
    public func map<C>(_ g: @escaping (B) throws -> C) -> Reader<A,C> {
        return Reader<A,C>({try g(self.f($0))})
    }
    
    public func flatMap<C>(_ g: @escaping (B) throws -> Reader<A,C>) -> Reader<A,C> {
        return Reader<A,C>({try g(self.f($0)).apply($0)})
    }
}
