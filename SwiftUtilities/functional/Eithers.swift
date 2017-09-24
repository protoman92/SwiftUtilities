//
//  Eithers.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/8/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import Foundation
import RxSwift

public extension EitherType where Left == Error {
    
    /// Get right or throw left.
    ///
    /// - Returns: Right instance.
    /// - Throws: Left if Right is not present.
    public func getOrThrow() throws -> Right {
        if let right = self.right {
            return right
        } else if let left = self.left {
            throw left
        } else {
            throw Exception("Invalid Either")
        }
    }
    
    public func asTry() -> Try<Right> {
        return Try({try self.getOrThrow()})
    }
}

public extension EitherType where Left: Error {
    
    /// Get right or throw left.
    ///
    /// - Returns: Right instance.
    /// - Throws: Left if Right is not present.
    public func getOrThrow() throws -> Right {
        return try projection.left.map({$0 as Error}).getOrThrow()
    }
    
    public func asTry() -> Try<Right> {
        return projection.left.map({$0 as Error}).asTry()
    }
}
