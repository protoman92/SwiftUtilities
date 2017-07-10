//
//  EitherUtil.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 29/6/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift

/// Use this to implement either-or behavior.
public protocol EitherConvertibleType {
    associatedtype L
    associatedtype R
    
    func asEither() -> Either<L,R>
}

public protocol EitherType: EitherConvertibleType, ReactiveCompatible {
    
    /// Get L, if available.
    var left: L? { get }
    
    /// Get R, if available.
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
    
    /// Get R with a fallback.
    ///
    /// - Parameter value: Fallback R value.
    /// - Returns: R instance.
    public func getOrElse(_ value: R) -> R {
        return right ?? value
    }
    
    /// Get R or throw the supplied Error if not available.
    ///
    /// - Parameter error: An Error instance.
    /// - Returns: R instance.
    /// - Throws: Error if right is not available.
    public func getOrThrow(_ error: Error) throws -> R {
        if let right = self.right {
            return right
        } else {
            throw error
        }
    }
    
    /// Map on both sides.
    ///
    /// - Parameters:
    ///   - f1: left-side map function.
    ///   - f2: right-side map function.
    /// - Returns: An Either instance.
    public func bimap<L1,R1>(_ f1: (L) -> L1, _ f2: (R) -> R1) -> Either<L1,R1> {
        return projection.left.map(f1).asEither().projection.right.map(f2).asEither()
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
    
    public func asEither() -> Either<L,R> {
        return self
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

extension Projection: EitherConvertibleType {
    public func asEither() -> Either<L,R> {
        return either
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
    
    public func map<L2>(_ f: (L) -> L2) -> Either<L2,R> {
        switch either {
        case .left(let left):
            return Either.left(f(left))
            
        case .right(let right):
            return Either.right(right)
        }
    }
    
    public func flatMap<L2,E>(_ f: (L) -> E) -> Either<L2,R>
        where E: EitherConvertibleType, E.L == L2, E.R == R
    {
        switch either {
        case .left(let left):
            return Either<L2,R>.from(f(left).asEither())
            
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
    
    public func map<R2>(_ f: (R) -> R2) -> Either<L,R2> {
        switch either {
        case .left(let left):
            return Either.left(left)
            
        case .right(let right):
            return Either.right(f(right))
        }
    }
    
    public func flatMap<R2,E>(_ f: (R) -> E) -> Either<L,R2>
        where E: EitherConvertibleType, E.L == L, E.R == R2
    {
        switch either {
        case .left(let left):
            return Either.left(left)
            
        case .right(let right):
            return Either<L,R2>.from(f(right).asEither())
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
            fatalError("Invalid Either")
        }
    }
}
