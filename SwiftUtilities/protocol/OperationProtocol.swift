//
//  OperationProtocol.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 4/11/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

/// Implement this protocol to provide a common interface for different 
/// operations.
protocol OperationProtocol {
    
    /// Call this method when an operation is initiated.
    func onOperationInitiated()
    
    /// Call this method when an operation throws an Error.
    ///
    /// - Parameter error: The Error thrown by the operation.
    func onOperationError(_ error: Error)
    
    /// Call this method when an operation is finished.
    func onOperationCompleted()
}
