//
//  EitherUtil.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 29/6/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import Result

/// Use this monad to implement either-or behavior.
public protocol EitherType {
    associatedtype L
    associatedtype R
    
    var left: L? { get }
    
    var right: R? { get }
}

public extension EitherType {
    
    /// Check if this Either is left.
    public var isLeft: Bool {
        return left != nil
    }
    
    /// Check if this Either is right.
    public var isRight: Bool {
        return right != nil
    }
    
    /// Since Either is non-biased by default, we need to access projections 
    /// for left/right bias.
    public var projection: Projection<L,R> {
        return Projection(Either<L,R>.from(self))
    }
    
    public func orElseGet(_ value: R) -> R {
        return right ?? value
    }
    
    public func orElseThrow(_ error: Error) throws -> R {
        if let right = self.right {
            return right
        } else {
            throw error
        }
    }
}

public enum Either<L,R> {
    case left(L)
    case right(R)
}

extension Either: EitherType {
    public var left: L? {
        switch self {
        case .left(let left):
            return left
            
        default:
            return nil
        }
    }
    
    public var right: R? {
        switch self {
        case .right(let right):
            return right
            
        default:
            return nil
        }
    }
}

/// We need to access the Projection for true monad behaviors.
public class Projection<L,R> {
    fileprivate let either: Either<L,R>
    
    fileprivate init(_ either: Either<L,R>) {
        self.either = either
    }
}

public extension Projection {
    
    /// Get LeftProjection.
    public var left: LeftProjection<L,R> {
        return LeftProjection(either)
    }
    
    /// Get RightProjection.
    public var right: RightProjection<L,R> {
        return RightProjection(either)
    }
}

/// Left-biased projection.
public final class LeftProjection<L,R>: Projection<L,R> {
    public var value: L? {
        return either.left
    }
    
    fileprivate override init(_ either: Either<L,R>) {
        super.init(either)
    }
    
    public func map<L2>(_ f: (L) throws -> L2) rethrows -> Either<L2,R> {
        switch either {
        case .left(let left):
            return Either.left(try f(left))
            
        case .right(let right):
            return Either.right(right)
        }
    }
    
    public func flatMap<L2,E>(_ f: (L) throws -> E) rethrows -> Either<L2,R>
        where E: EitherType, E.L == L2, E.R == R
    {
        switch either {
        case .left(let left):
            return Either<L2,R>.from(try f(left))
            
        case .right(let right):
            return Either.right(right)
        }
    }
}

/// Right-biased projection.
public final class RightProjection<L,R>: Projection<L,R> {
    public var value: R? {
        return either.right
    }
    
    fileprivate override init(_ either: Either<L,R>) {
        super.init(either)
    }
    
    public func map<R2>(_ f: (R) throws -> R2) rethrows -> Either<L,R2> {
        switch either {
        case .left(let left):
            return Either.left(left)
            
        case .right(let right):
            return Either.right(try f(right))
        }
    }
    
    public func flatMap<R2,E>(_ f: (R) throws -> E) rethrows -> Either<L,R2>
        where E: EitherType, E.L == L, E.R == R2
    {
        switch either {
        case .left(let left):
            return Either.left(left)
            
        case .right(let right):
            return Either<L,R2>.from(try f(right))
        }
    }
}

public extension Either {
    fileprivate static func from<L,R,E>(_ either: E) -> Either<L,R>
        where E: EitherType, E.L == L, E.R == R
    {
        if let left = either.left {
            return Either<L,R>.left(left)
        } else if let right = either.right {
            return Either<L,R>.right(right)
        } else {
            fatalError("Invalid either")
        }
    }
}
