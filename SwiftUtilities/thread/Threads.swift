//
//  Threads.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 1/13/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

public extension DispatchQueue {
  private static var _onceTracker = [String]()

  /// Executes a block of code, associated with a unique token, only once.
  /// The code is thread safe and will only execute the code once even in
  /// the presence of multithreaded calls.
  ///
  /// - Parameters:
  ///   - token: A unique reverse DNS style name or a GUID.
  ///   - block: Block to execute once.
  public class func once(using token: String, then block: (()) -> Void) {
    synchronized(self) {
      guard !_onceTracker.contains(token) else {
        return
      }

      _onceTracker.append(token)
      block(())
    }
  }
}

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

/// Perform an action only once.
///
/// - Parameters:
///   - token: A unique reverse DNS style name or a GUID.
///   - block: Block to execute once.
public func once(using token: String, then block: () -> Void) {
  DispatchQueue.once(using: token, then: block)
}

/// Synchronize access to a lock, and perform an operation.
///
/// - Parameters:
///   - lock: The object to be locked.
///   - body: Action closure.
/// - Returns: An arbitrary object.
/// - Throws: An Error that could be thrown by body.
public func synchronized<T>(_ lock: AnyObject,
                            then body: () throws -> T) rethrows -> T {
  objc_sync_enter(lock)
  defer { objc_sync_exit(lock) }
  return try body()
}
