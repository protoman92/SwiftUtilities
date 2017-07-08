//
//  Try.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/8/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

/// Use this monad to wrap operations that can throw Error.
public protocol TryConvertibleType {
    associatedtype A
    
    func asTry() -> Try<A>
}

public protocol TryType: TryConvertibleType, EitherConvertibleType {
    
    /// Get the success value.
    var value: A? { get }
    
    /// Get the failure error.
    var error: Error? { get }
}

public extension TryType {
    public func asEither() -> Either<Error,A> {
        if let value = self.value {
            return Either.right(value)
        } else if let error = self.error {
            return Either.left(error)
        } else {
            fatalError("Invalid Try")
        }
    }
    
    /// Check if the operation was successful.
    var isSuccess: Bool {
        return value != nil
    }
    
    /// Check if the operation failed.
    var isFailure: Bool {
        return !isSuccess
    }
}

public extension TryType {
    public func map<A2>(_ f: (A) throws -> A2) -> Try<A2> {
        if let value = self.value {
            return Try({try f(value)})
        } else if let error = self.error {
            return Try({() throws -> A2 in throw error})
        } else {
            fatalError("Invalid Try")
        }
    }
    
    public func flatMap<T,A2>(_ f: (A) throws -> T) -> Try<A2>
        where T: TryConvertibleType, T.A == A2
    {
        if let value = self.value {
            do {
                return try f(value).asTry()
            } catch let error {
                return Try({_ in throw error})
            }
        } else if let error = self.error {
            return Try({_ in throw error})
        } else {
            fatalError("Invalid Try")
        }
    }
}

public enum Try<A> {
    case success(A)
    case failure(Error)
    
    public init(_ f: () throws -> A) {
        do {
            self = .success(try f())
        } catch let error {
            self = .failure(error)
        }
    }
    
    public init(_ value: A) {
        self = .success(value)
    }
    
    public init(_ error: Error) {
        self = .failure(error)
    }
}

extension Try: TryType {
    public var value: A? {
        switch self {
        case .success(let value):
            return value
            
        default:
            return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .failure(let error):
            return error
            
        default:
            return nil
        }
    }
    
    public func asTry() -> Try<A> {
        return self
    }
}
