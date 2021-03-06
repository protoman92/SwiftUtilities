//
//  Exceptions.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 1/18/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

extension Exception: IsInstanceType {}

/// Assert the validity of a statement, if debugging is active.
///
/// - Parameters:
///   - statement: A Bool statement.
///   - file: The file in which the statement is found.
///   - line: The line at which the statement is found.
///   - function: The function in which the statement is found.
///   - message: A custom message to be printed if the assert fails.
public func assertDebug(_ statement: Bool,
                        file: String = #file,
                        line: Int = #line,
                        function: String = #function,
                        message: String? = nil) {
  if isInDebugMode() {
    let message = message ?? "none"

    let error =
      "File \(file), " +
        "on line \(line), " +
        "in function \(function). " +
    "Message: \(message)"

    assert(statement, error)
  }
}

/// Assert that an object is not null, if debugging is active.
///
/// - Parameters:
///   - statement: A Bool statement.
///   - file: The file in which the statement is found.
///   - line: The line at which the statement is found.
///   - function: The function in which the statement is found.
///   - message: A custom message to be printed if the assert fails.
public func assertNotNullDebug(_ object: Any?,
                               file: String = #file,
                               line: Int = #line,
                               function: String = #function) {
  assertDebug(object != nil, file: file, line: line, function: function)
}

/// Check is debugging is active.
///
/// - Returns: A Bool value.
public func isInDebugMode() -> Bool {
  #if DEBUG
    return true
  #else
    return false
  #endif
}

/// Throw an error, if debugging is active.
///
/// - Parameters:
///   - statement: A Bool statement.
///   - file: The file in which the statement is found.
///   - line: The line at which the statement is found.
///   - function: The function in which the statement is found.
///   - message: A custom message to be printed if the assert fails.
public func debugException(_ message: String? = nil,
                           file: String = #file,
                           line: Int = #line,
                           function: String = #function) {
  if isInDebugMode() {
    let message = message ?? ""

    let error =
      "File \(file), " +
        "on line \(line), " +
        "in function \(function). " +
    "Message: \(message)"

    fatalError(error)
  }
}

public struct Exception: Error {
  fileprivate let message: String
  fileprivate var error: Error?

  public init(_ message: String?) {
    self.message = message ?? ""
  }

  public init(_ error: Error) {
    self.init(error.localizedDescription)
    self.error = error
  }

  public init(_ exception: Exception) {
    self.init(exception.cause)
  }

  public init() {
    self.init(nil)
  }
}

extension Exception: LocalizedError {

  /// Sometimes the actual cause is not the current Exception itself, but
  /// another Error with more information.
  public var cause: Error {
    return error ?? self
  }

  public var localizedDescription: String {
    return errorDescription ?? ""
  }

  public var errorDescription: String? {
    return message
  }
}
