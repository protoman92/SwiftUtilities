//
//  Enums.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 8/14/17.
//  Copyright © 2017 Holmusk. All rights reserved.
//

/// Enums that implement this protocol must be able to provide an Array of all
/// their cases.
public protocol EnumerableType {

  /// Produce an Array of all enum cases.
  ///
  /// - Returns: An Array of Self.
  static func allValues() -> [Self]
}

public extension EnumerableType {

  /// Get a random enum case.
  ///
  /// - Returns: A Self instance.
  public static func randomValue() -> Self? {
    return allValues().randomElement()
  }
}
