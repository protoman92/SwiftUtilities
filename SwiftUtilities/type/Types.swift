//
//  Types.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 4/17/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

/// This protocol provides methods to determine whether an object is of a
/// particular type.
public protocol IsInstanceType {}

public extension IsInstanceType {

  /// Check if an object is of this type.
  ///
  /// - Parameter object: An object to be inspected.
  /// - Returns: A Bool value.
  public static func isType(of object: Any?) -> Bool {
    guard let object = object else {
      return false
    }

    return Mirror(reflecting: object).subjectType == self
  }

  /// Check if the current NSObject is an instance of a specified Type.
  ///
  /// - Parameter type: The Type to be checked.
  /// - Returns: A Bool value.
  public func isInstance<T>(of type: T.Type) -> Bool {
    return Mirror(reflecting: self).subjectType == type
  }
}

extension NSObject: IsInstanceType {}
