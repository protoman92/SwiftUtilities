//
//  EitherUtil.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 29/6/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import Result

/// This typealias helps hide the dependency on Result so that later if we
/// want to use a dedicated Either dependency, we can simply switch without
/// consequence.
public typealias Either<E: Error,T> = Result<T,E>

public extension Either {
    
    /// Get an Error Result.
    public static func left(_ error: Result.Error) -> Either<Result.Error,T> {
        return Result(error: error)
    }
    
    /// Get a T Result.
    public static func right(_ value: T) -> Either<Result.Error,T> {
        return Result(value)
    }
    
    /// Create an Exception left Either based on an Error. This is to circumvent
    /// Result constraint on Error.
    public static func exception<V>(from error: Swift.Error) -> Either<Exception,V> {
        if let exception = error as? Exception {
            return Either<Exception,V>.left(exception)
        } else {
            return Either<Exception,V>.left(Exception(error))
        }
    }
}

public extension Either {
    public var left: Result.Error? {
        return error
    }
    
    public var right: Result.Value? {
        return value
    }

    /// Check if this Either is left.
    public var isLeft: Bool {
        return left != nil
    }
    
    /// Check if this Either is right.
    public var isRight: Bool {
        return right != nil
    }
    
    /// Same as ResultProtocol.flatMapError(_:).
    public func flatMapLeft<E2>(_ transform: (Result.Error) -> Either<E2,Result.Value>) -> Either<E2,Result.Value> {
        return flatMapError(transform)
    }
    
    /// Same as ResultProtocol.flatMap(_:).
    public func flatMapRight<U>(_ transform: (Result.Value) -> Either<Result.Error,U>) -> Either<Result.Error,U> {
        return flatMap(transform)
    }
    
    /// Same as ResultProtocol.mapError(_:).
    public func mapLeft<E2>(_ transform: (Result.Error) -> E2) -> Either<E2,Result.Value> {
        return mapError(transform)
    }
    
    /// Same as ResultProtocol.map(_:).
    public func mapRight<U>(_ transform: (Result.Value) -> U) -> Either<Result.Error,U> {
        return map(transform)
    }
    
    /// Same as ResultProtocol.recover(_:).
    public func orElseGet(_ value: Result.Value) -> Result.Value {
        return recover(value)
    }
    
    /// Throw an Error if there is no right value.
    public func orElseThrow(_ error: Error) throws -> Result.Value {
        if let value = self.value {
            return value
        } else {
            throw error
        }
    }
    
    /// Get right, or throw left.
    public func rightOrThrow() throws -> Result.Value {
        switch self {
        case .success(let value):
            return value
            
        case .failure(let error):
            throw error
        }
    }
}
