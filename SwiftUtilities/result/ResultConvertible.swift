//
//  ResultConvertible.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 6/28/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import Result

/// Implement this protocol to create Result from self.
public protocol ResultConvertibleType {}

public extension ResultConvertibleType {
    
    /// Create a new Result instance.
    ///
    /// - Returns: A Result instance.
    public func toResult<E: Error>() -> Result<Self,E> {
        return Result<Self,E>(self)
    }
}
