//
//  State.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/10/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift

/// Use this to store, modify and pass state information.
public typealias StatePair<S,A> = (state: S, value: A)

public protocol StateConvertibleType {
    associatedtype A
    associatedtype S
    
    func asState() -> State<S,A>
}

public protocol StateType: StateConvertibleType, ReactiveCompatible {
    var f: (S) throws -> StatePair<S,A> { get }
}

public extension StateType {
    public func run(_ s: S) throws -> StatePair<S,A> {
        return try f(s)
    }
    
    public func tryRun(_ s: S) -> Try<StatePair<S,A>> {
        return Try({try self.run(s)})
    }
    
    public func run1(_ s: S) throws -> S {
        return try run(s).state
    }
    
    public func tryRun1(_ s: S) -> Try<S> {
        return Try({try self.run1(s)})
    }
    
    public func run2(_ s: S) throws -> A {
        return try run(s).value
    }
    
    public func tryRun2(_ s: S) -> Try<A> {
        return Try({try self.run2(s)})
    }
    
    /// Change state signature with a transform function.
    ///
    /// - Parameter g: Transform function.
    /// - Returns: A State instance.
    public func modify<S1>(_ g: @escaping (S1) throws -> S) -> State<S1,A> {
        return State({try StatePair($0, self.run2(g($0)))})
    }
    
    /// Modify the state with the same type.
    ///
    /// - Parameter g: Transform function.
    /// - Returns: A State instance.
    public func modify(_ g: @escaping (S) throws -> S) -> State<S,A> {
        return State({
            let (s, a) = try self.run($0)
            return try StatePair(g(s), a)
        })
    }
    
    /// Functor.
    ///
    /// - Parameter g: Transform function.
    /// - Returns: A State instance.
    public func map<A1>(_ g: @escaping (A) throws -> A1) -> State<S,A1> {
        return State({
            let (s, a) = try self.run($0)
            return try StatePair(s, g(a))
        })
    }
    
    /// Applicative.
    ///
    /// - Parameter st: A StateConvertibleType instance.
    /// - Returns: A State instance.
    public func apply<ST,A1>(_ st: ST) -> State<S,A1>
        where ST: StateConvertibleType, ST.S == S, ST.A == (A) throws -> A1
    {
        return flatMap({a in st.asState().map({try $0(a)})})
    }
    
    /// Monad.
    ///
    /// - Parameter g: Transform function.
    /// - Returns: A State instance.
    public func flatMap<ST,A1>(_ g: @escaping (A) throws -> ST) -> State<S,A1>
        where ST: StateConvertibleType, ST.S == S, ST.A == A1
    {
        return State({
            let (s, a) = try self.run($0)
            return try g(a).asState().run(s)
        })
    }
}

public struct State<S,A> {
    public let f: (S) throws -> StatePair<S,A>
    
    public init(_ f: @escaping (S) throws -> (S, A)) {
        self.f = f
    }
}

extension State: StateType {
    public func asState() -> State<S,A> {
        return self
    }
}
