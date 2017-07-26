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
