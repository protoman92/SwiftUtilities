//
//  ThreadUtil.swift
//  Heartland Chefs
//
//  Created by Hai Pham on 1/13/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import Foundation

/// Delay execution in the main thread by some time.
///
/// - Parameters:
///   - delay: The time interval to delay.
///   - closure: The action to be performed after the delay.
public func delay(_ delay: TimeInterval, closure: @escaping () -> Void) {
    let nsec = Double(NSEC_PER_SEC)
    let timeDelay = Double(Int64(delay * nsec)) / nsec
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeDelay,
                                  execute: closure)
}

/// Perform an operation on the main thread.
///
/// - Parameter closure: The action to be performed on the main thread.
public func mainThread(_ closure: @escaping () -> Void) {
    DispatchQueue.main.async(execute: closure)
}

/// Perform an action asynchronously.
///
/// - Parameters:
///   - qos: Quality of Service level.
///   - closure: The action to be performed asynchronously.
public func background(_ qos: DispatchQoS.QoSClass? = nil,
                       closure: @escaping () -> Void) {
    let qos = qos ?? .userInteractive
    DispatchQueue.global(qos: qos).async(execute: closure)
}
