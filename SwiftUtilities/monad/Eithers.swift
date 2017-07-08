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
    public func getOrThrow() throws -> R {
        if let right = self.right {
            return right
        } else if let left = self.left {
            throw left
        } else {
            throw Exception("Invalid Either")
        }
    }
    
    public func asTry() -> Try<R> {
        return Try({try self.getOrThrow()})
    }
}

public extension EitherType where L: Error {
    
    /// Get right or throw left.
    ///
    /// - Returns: R instance.
    /// - Throws: L if R is not present.
    public func getOrThrow() throws -> R {
        return try projection.left.map({$0 as Error}).getOrThrow()
    }
    
    public func asTry() -> Try<R> {
        return projection.left.map({$0 as Error}).asTry()
    }
}
