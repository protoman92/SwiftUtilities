//
//  Readers.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/8/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import RxCocoa

public typealias RxReader<L,R> = Reader<L,Observable<R>>

public extension Reader {
    
    /// Get a Reader whose f simply returns whatever is passed in.
    ///
    /// - Returns: A Reader instance.
    public static func eq<A>() -> Reader<A,A> {
        return Reader<A,A>({$0})
    }
    
    /// Get a Reader whose f simply returns a value.
    ///
    /// - Parameter value: B instance.
    /// - Returns: A Reader instance.
    public static func just<A,B>(_ value: B) -> Reader<A,B> {
        return Reader<A,B>({_ in value})
    }
}

public extension Reactive where Base: ReaderType, Base.B: ObservableConvertibleType {
    
    /// If the current Reader's f function returns an Observable wrapped in a
    /// Try, unwrap it.
    ///
    /// - Parameter a: A instance.
    /// - Returns: An Observable instance.
    public func apply(_ a: Base.A) -> Observable<Base.B.E> {
        let base = self.base
        
        do {
            let inner = try base.applyOrThrow(a)
            return inner.asObservable()
        } catch let error {
            return Observable.error(error)
        }
    }
}

public extension Reactive where Base: ReaderType, Base.B: ObservableConvertibleType {
    
    /// If the current Reader's f function returns an Observable, flatten and
    /// wrap the Observable emission in a Try instance.
    ///
    /// - Parameter a: A instance.
    /// - Returns: An Observable instance.
    public func tryApply(_ a: Base.A) -> Observable<Try<Base.B.E>> {
        return apply(a)
            .map(Try<Base.B.E>.success)
            .catchErrorJustReturn(Try<Base.B.E>.failure)
    }
}

public extension Reactive where Base: ReaderType, Base.B: ObservableConvertibleType, Base.B.E: TryConvertibleType {
    
    /// If the current Reader's f function returns an Observable that emits a
    /// TryConvertibleType, flatten and wrap the Observable emission in a Try
    /// instance.
    ///
    /// This is a more specified version of apply() as defined above.
    ///
    /// - Parameter a: A instance.
    /// - Returns: An Observable instance.
    public func apply(_ a: Base.A) -> Observable<Try<Base.B.E.A>> {
        let base = self.base
        
        do {
            let inner = try base.applyOrThrow(a)
            
            return inner.asObservable()
                .map({$0.asTry()})
                .catchErrorJustReturn(Try<Base.B.E.A>.failure)
        } catch let error {
            return Observable.just(Try<Base.B.E.A>.failure(error))
        }
    }
}

extension Reader: ReactiveCompatible {}
