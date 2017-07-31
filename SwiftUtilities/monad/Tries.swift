//
//  Tries.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/8/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxCocoa
import RxSwift

public typealias RxTry<Val> = Try<Observable<Val>>

public extension Reactive where Base: TryConvertibleType {
    
    /// Wrap the success/error in an Observable.
    ///
    /// - Returns: An Observable instance.
    public func get() -> Observable<Base.Val> {
        do {
            return Observable.just(try base.asTry().getOrThrow())
        } catch let error {
            return Observable.error(error)
        }
    }
}

extension Optional: TryConvertibleType {
    public typealias Val = Wrapped
    
    /// Convert this Optional into a Try.
    ///
    /// - Returns: A Try instance.
    public func asTry() -> Try<Val> {
        return Try<Val>.from(optional: self)
    }
    
    /// Convert this Optional into a Try.
    ///
    /// - Parameter error: An Error instance.
    /// - Returns: A Try instance.
    public func asTry(error: Error) -> Try<Val> {
        return Try<Val>.from(optional: self, error: error)
    }
    
    /// Convert this Optional into a Try.
    ///
    /// - Parameter error: A String value.
    /// - Returns: A Try instance.
    public func asTry(error: String) -> Try<Val> {
        return asTry(error: Exception(error))
    }
}
