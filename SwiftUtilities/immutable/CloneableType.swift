//
//  CloneableType.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 17/8/17.
//  Copyright © 2017 Holmusk. All rights reserved.
//

/// Classes that implement this protocol must be able to clone itself by
/// creating a new instance of the same type and copying properties to it.
public protocol CloneableType {

  /// Produce a clone of the current object.
  ///
  /// - Returns: A Self instance.
  func cloned() -> Self
}
