//
//  Readers.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/8/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import RxCocoa

public typealias RxReader<Env,Val> = Reader<Env,Observable<Val>>

/// A Reader that has the same signature for A and B.
public typealias EQReader<A> = Reader<A,A>

public extension Reader {
    
    /// Get a Reader whose f simply returns whatever is passed in.
    ///
    /// - Returns: A Reader instance.
    public static func eq<Env>() -> EQReader<Env> {
        return Reader<Env,Env>({$0})
    }
    
    /// Get a Reader whose f simply returns a value.
    ///
    /// - Parameter value: Base.Val instance.
    /// - Returns: A Reader instance.
    public static func just<Env,Val>(_ value: Val) -> Reader<Env,Val> {
        return Reader<Env,Val>({_ in value})
    }
    
    /// Convenient method to zip two ReaderConvertibleType.
    ///
    /// - Parameters:
    ///   - r1: R1 instance.
    ///   - r2: R2 instance.
    ///   - g: Transform function.
    /// - Returns: A Reader instance.
    public static func zip<R1,R2,Env,Val,Val1,U>(_ r1: R1, _ r2: R2,
                           _ g: @escaping (Val, Val1) throws -> U)
        -> Reader<Env,U> where
        R1: ReaderConvertibleType,
        R2: ReaderConvertibleType,
        R1.Env == Env, R1.Val == Val,
        R2.Env == Env, R2.Val == Val1
    {
        return r1.asReader().zip(with: r2, g)
    }
    
    /// Convenient method to zip two ReaderConvertibleType.
    ///
    /// - Parameters:
    ///   - r1: R1 instance.
    ///   - r2: R2 instance.
    ///   - g: Transform function.
    /// - Returns: A Reader instance.
    public static func zip<R1,R2,Env,Val,Env1,Val1,U>(_ r1: R1, _ r2: R2,
                           _ g: @escaping (Val, Val1) throws -> U)
        -> Reader<(Env, Env1),U> where
        R1: ReaderConvertibleType,
        R2: ReaderConvertibleType,
        R1.Env == Env, R1.Val == Val,
        R2.Env == Env1, R2.Val == Val1
    {
        return r1.asReader().zip(with: r2, g)
    }
    
    /// Zip a Sequence of ReaderConvertibleType using a function.
    ///
    /// - Parameters:
    ///   - readers: A Sequence of ReaderConvertibleType.
    ///   - g: Transform function.
    /// - Returns: A Reader instance.
    public static func zip<S,Env,Val,Val1>(_ readers: S,
                           _ g: @escaping ([Val]) throws -> Val1)
        -> Reader<Env,Val1> where
        S: Sequence,
        S.Iterator.Element: ReaderConvertibleType,
        S.Iterator.Element.Env == Env,
        S.Iterator.Element.Val == Val
    {
        return Reader<Env,Val1>({(env: Env) throws -> Val1 in
            try g(readers.map({$0.asReader()}).map({try $0.run(env)}))
        })
    }
    
    /// Same as above, but uses varargs of ReaderConvertibleType.
    ///
    /// - Parameters:
    ///   - g: Transform function.
    ///   - readers: Varargs of ReaderConvertibleType.
    /// - Returns: A Reader instance.
    public static func zip<R,Env,Val,Val1>(_ g: @escaping ([Val]) throws -> Val1,
                           _ readers: R...)
        -> Reader<Env,Val1> where
        R: ReaderConvertibleType,
        R.Env == Env, R.Val == Val
    {
        return Reader.zip(readers.map({$0}), g)
    }
    
    /// Zip a Sequence of ReaderConvertibleType using a function that is applied
    /// only on those that do not produce errors while running on some Env
    /// instance.
    ///
    /// - Parameters:
    ///   - readers: A Sequence of ReaderConvertibleType.
    ///   - g: Transform function.
    /// - Returns: A Reader instance.
    public static func zip<S,Env,Val,Val1>(ignoringErrors readers: S,
                           _ g: @escaping ([Val]) throws -> Val1)
        -> Reader<Env,Val1> where
        S: Sequence,
        S.Iterator.Element: ReaderConvertibleType,
        S.Iterator.Element.Env == Env,
        S.Iterator.Element.Val == Val
    {
        return Reader<Env,Val1>({(env: Env) throws -> Val1 in
            try g(readers
                .map({$0.asReader()})
                .map({$0.tryRun(env)})
                .flatMap({$0.value}))
        })
    }
    
    /// Same as above, but uses varargs of ReaderConvertibleType.
    ///
    /// - Parameters:
    ///   - g: Transform function.
    ///   - readers: Varargs of ReaderConvertibleType.
    /// - Returns: A Reader instance.
    public static func zip<R,Env,Val,Val1>(_ g: @escaping ([Val]) throws -> Val1,
                           ignoringErrors readers: R...)
        -> Reader<Env,Val1> where
        R: ReaderConvertibleType,
        R.Env == Env, R.Val == Val
    {
        return Reader.zip(ignoringErrors: readers.map({$0}), g)
    }
}

//public extension Reactive where Base: ReaderConvertibleType {
//
//    /// Run the Reader and throw Error if encountered.
//    ///
//    /// - Parameter env: Base.Env instance.
//    /// - Returns: An Observable instance.
//    public func run(_ env: Base.Env) -> Observable<Base.Val> {
//        return base.asReader().tryRun(env).rx.get()
//    }
//}
//
//public extension Reactive where
//    Base: ReaderConvertibleType,
//    Base.Val: ObservableConvertibleType {
//
//    /// If the current Reader's f function returns an Observable, flatten it
//    /// to avoid nested Observable.
//    ///
//    /// - Parameter env: Base.Env instance.
//    /// - Returns: An Observable instance.
//    public func flatRun(_ env: Base.Env) -> Observable<Base.Val.E> {
//        return run(env).flatMap(eq)
//    }
//
//    /// If the current Reader's f function returns an Observable, flatten and
//    /// wrap the Observable emission in a Try instance.
//    ///
//    /// - Parameter env: Base.Env instance.
//    /// - Returns: An Observable instance.
//    public func tryFlatRun(_ env: Base.Env) -> Observable<Try<Base.Val.E>> {
//        return flatRun(env)
//            .map(Try<Base.Val.E>.success)
//            .catchErrorJustReturn(Try<Base.Val.E>.failure)
//    }
//}
//
//public extension Reactive where
//    Base: ReaderConvertibleType,
//    Base.Val: ObservableConvertibleType,
//    Base.Val.E: TryConvertibleType {
//
//    /// If the current Reader's f function returns an Observable that emits a
//    /// TryConvertibleType, flatten and wrap the Observable emission in a Try
//    /// instance.
//    ///
//    /// This is a more specified version of flatRun(_:) as defined above. The
//    /// original version will throw an Error if the Reader function throws.
//    /// This version simply catches that Error and wrap it in another Try.
//    ///
//    /// - Parameter env: Base.Env instance.
//    /// - Returns: An Observable instance.
//    public func flatRun(_ env: Base.Env) -> Observable<Try<Base.Val.E.Val>> {
//        return tryFlatRun(env).map({$0.flatMap(eq)})
//    }
//}

