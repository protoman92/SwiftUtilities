//
//  EitherUtil.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 29/6/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import Result

/// This typealias helps hide the dependency on Result.
public typealias Either<E: Error,T> = Result<T,E>

public extension Either {
    
    /// Get an Error Result.
    ///
    /// - Parameter error: An Error instance.
    /// - Returns: An Either instance.
    public static func left(_ error: Error) -> Either<Error,T> {
        return Result(error: error)
    }
    
    /// Get a T Result.
    ///
    /// - Parameter value: A T instance.
    /// - Returns: An Either instance.
    public static func right(_ value: T) -> Either<Error,T> {
        return Result(value)
    }
}
