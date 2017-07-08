//
//  Eithers.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/8/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import Foundation
import RxSwift

public extension EitherType where L == Error {
    
    /// Get right or throw left.
    ///
    /// - Returns: R instance.
    /// - Throws: L if R is not present.
    public func rightOrThrow() throws -> R {
        if let right = self.right {
            return right
        } else if let left = self.left {
            throw left
        } else {
            throw Exception("Invalid EitherType")
        }
    }
}

public extension EitherType where L: Error {
    
    /// Get right or throw left.
    ///
    /// - Returns: R instance.
    /// - Throws: L if R is not present.
    public func rightOrThrow() throws -> R {
        return try projection.left.map({$0 as Error}).rightOrThrow()
    }
}

public typealias ErrorEither<R> = Either<Error,R>