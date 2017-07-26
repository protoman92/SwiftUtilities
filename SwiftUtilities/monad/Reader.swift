//
//  Reader.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/8/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift

/// Use this to implement Dependency Injection.
public protocol ReaderConvertibleType {
    associatedtype Env
    associatedtype Val
    
    func asReader() -> Reader<Env,Val>
}

public protocol ReaderType: ReaderConvertibleType, ReactiveCompatible {
    var f: (Env) throws -> Val { get }
}

public extension ReaderType {
    
    public func run(_ a: Env) throws -> Val {
        return try f(a)
    }

    /// Call f and wrap the result in a Try.
    ///
    /// - Parameter a: Env instance.
    /// - Returns: A Try instance.
    public func tryRun(_ env: Env) -> Try<Val> {
        return Try({try self.run(env)})
    }
    
    /// Modify the environment with which to execute the function.
    ///
    /// - Parameter g: Tranform function.
    /// - Returns: A Reader instance.
    public func modify<Env1>(_ g: @escaping (Env1) throws -> Env) -> Reader<Env1,Val> {
        return Reader({try self.run(g($0))})
    }
    
    /// Functor.
    ///
    /// - Parameter g: Transform function.
    /// - Returns: A Reader instance.
    public func map<Val1>(_ g: @escaping (Val) throws -> Val1) -> Reader<Env,Val1> {
        return Reader<Env,Val1>({try g(self.run($0))})
    }
    
    /// Applicative.
    ///
    /// - Parameter r: ReaderConvertibleType instance.
    /// - Returns: A Reader instance.
    public func apply<R,Val1>(_ r: R) -> Reader<Env,Val1>
        where R: ReaderConvertibleType, R.Env == Env, R.Val == (Val) throws -> Val1
    {
        return flatMap({val in r.asReader().map({try $0(val)})})
    }
    
    /// Monad.
    ///
    /// - Parameter g: Transform function.
    /// - Returns: A Reader instance.
    public func flatMap<R,Val1>(_ g: @escaping (Val) throws -> R) -> Reader<Env,Val1>
        where R: ReaderConvertibleType, R.Env == Env, R.Val == Val1
    {
        return Reader<Env,Val1>({try g(self.f($0)).asReader().run($0)})
    }
    
    /// Zip with another ReaderConvertibleType.
    ///
    /// - Parameters:
    ///   - reader: A ReaderConvertibleType instance.
    ///   - g: Transform function.
    /// - Returns: A Reader instance.
    public func zip<R,Val1,U>(with reader: R, _ g: @escaping (Val, Val1) throws -> U)
        -> Reader<Env,U> where R: ReaderConvertibleType, R.Env == Env, R.Val == Val1
    {
        return flatMap({val in reader.asReader().map({try g(val, $0)})})
    }
    
    /// Zip with another ReaderConvertibleType with a different A.
    ///
    /// - Parameters:
    ///   - reader: A ReaderConvertibleType instance.
    ///   - g: Transform function.
    /// - Returns: A Reader instance.
    public func zip<R,Env1,Val1,U>(with reader: R, _ g: @escaping (Val, Val1) throws -> U)
        -> Reader<(Env,Env1),U> where R: ReaderConvertibleType, R.Env == Env1, R.Val == Val1
    {
        return Reader({try g(self.run($0.0), reader.asReader().run($0.1))})
    }
}

public struct Reader<Env,Val> {
    public let f: (Env) throws -> Val
    
    public init(_ f: @escaping (Env) throws -> Val) {
        self.f = f
    }
}

extension Reader: ReaderType {
    public func asReader() -> Reader<Env,Val> {
        return self
    }
}
