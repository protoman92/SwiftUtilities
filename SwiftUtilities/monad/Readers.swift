//
//  Readers.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/8/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import RxCocoa

public typealias RxReader<A,B> = Reader<A,Observable<B>>

/// A Reader that has the same signature for A and B.
public typealias EQReader<A> = Reader<A,A>

public extension Reader {
    
    /// Get a Reader whose f simply returns whatever is passed in.
    ///
    /// - Returns: A Reader instance.
    public static func eq<A>() -> EQReader<A> {
        return Reader<A,A>({$0})
    }
    
    /// Get a Reader whose f simply returns a value.
    ///
    /// - Parameter value: B instance.
    /// - Returns: A Reader instance.
    public static func just<A,B>(_ value: B) -> Reader<A,B> {
        return Reader<A,B>({_ in value})
    }
    
    /// Convenient method to zip two ReaderConvertibleType.
    ///
    /// - Parameters:
    ///   - r1: R1 instance.
    ///   - r2: R2 instance.
    ///   - g: Transform function.
    /// - Returns: A Reader instance.
    public static func zip<A,B,B1,R1,R2,U>(_ r1: R1, _ r2: R2,
                           _ g: @escaping (B, B1) -> U)
        -> Reader<A,U> where
        R1: ReaderConvertibleType,
        R2: ReaderConvertibleType,
        R1.A == A, R1.B == B,
        R2.A == A, R2.B == B1
    {
        return r1.asReader().zip(with: r2, g)
    }
}

public extension Reactive where
    Base: ReaderConvertibleType,
    Base.B: ObservableConvertibleType {
    
    /// If the current Reader's f function returns an Observable wrapped in a
    /// Try, unwrap it.
    ///
    /// - Parameter a: A instance.
    /// - Returns: An Observable instance.
    public func run(_ a: Base.A) -> Observable<Base.B.E> {
        let base = self.base
        
        do {
            let inner = try base.asReader().f(a)
            return inner.asObservable()
        } catch let error {
            return Observable.error(error)
        }
    }
}

public extension Reactive where
    Base: ReaderConvertibleType,
    Base.B: ObservableConvertibleType {
    
    /// If the current Reader's f function returns an Observable, flatten and
    /// wrap the Observable emission in a Try instance.
    ///
    /// - Parameter a: A instance.
    /// - Returns: An Observable instance.
    public func tryRun(_ a: Base.A) -> Observable<Try<Base.B.E>> {
        return run(a)
            .map(Try<Base.B.E>.success)
            .catchErrorJustReturn(Try<Base.B.E>.failure)
    }
}

public extension Reactive where
    Base: ReaderConvertibleType,
    Base.B: ObservableConvertibleType,
    Base.B.E: TryConvertibleType {
    
    /// If the current Reader's f function returns an Observable that emits a
    /// TryConvertibleType, flatten and wrap the Observable emission in a Try
    /// instance.
    ///
    /// This is a more specified version of apply() as defined above. The
    /// original version will throw an Error if the Reader is not available.
    /// This version simply catches that Error and wrap it in another Try.
    ///
    /// - Parameter a: A instance.
    /// - Returns: An Observable instance.
    public func run(_ a: Base.A) -> Observable<Try<Base.B.E.A>> {
        return tryRun(a).map({$0.flatMap(eq)})
    }
}

extension Reader: ReactiveCompatible {}
