//
//  Localizer.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 15/12/17.
//  Copyright © 2017 Holmusk. All rights reserved.
//

/// Simple localizer that localizes String dynamically.
public struct Localizer {
  fileprivate var bundles: [Bundle]
  fileprivate var tables: [String]

  public init() {
    bundles = []
    tables = []
  }
}

extension Localizer: LocalizerType {

  /// Override this method to provide default implementation.
  ///
  /// - Parameter value: A String value.
  /// - Returns: A String value.
  public func localize(_ value: String) -> String {
    let tables = self.tables

    for bundle in bundles {
      let localized = value.localize(bundle, tables)

      if localized != value {
        return localized
      }
    }

    return value
  }
}

extension Localizer: BuildableType {
  public static func builder() -> Builder {
    return Builder()
  }

  public final class Builder {
    fileprivate var localizer: Localizer

    public init() {
      localizer = Localizer()
    }

    /// Add a Sequence of Bundles to the list of available Bundles.
    ///
    /// - Parameter bundles: A Sequence of Bundles.
    /// - Returns: The current Builder instance.
    @discardableResult
    public func add<S>(bundles: S) -> Self where S: Sequence, S.Element == Bundle {
      localizer.bundles.append(contentsOf: bundles)
      return self
    }

    /// Add a Bundle to the list of available Bundles.
    ///
    /// - Parameter bundle: A Bundle instance.
    /// - Returns: The current Builder instance.
    @discardableResult
    public func add(bundle: Bundle) -> Self {
      localizer.bundles.append(bundle)
      return self
    }

    /// Replace the current bundles.
    ///
    /// - Parameter table: A Sequence of Bundles.
    /// - Returns: The current Builder instance.
    @discardableResult
    public func with<S>(bundles: S) -> Self where S: Sequence, S.Element == Bundle {
      localizer.bundles = bundles.map({$0})
      return self
    }

    /// Add a Sequence of Strings to the list of available tables.
    ///
    /// - Parameter tables: A Sequence of Strings.
    /// - Returns: THe current Builder instance.
    @discardableResult
    public func add<S>(tables: S) -> Self where S: Sequence, S.Element == String {
      localizer.tables.append(contentsOf: tables)
      return self
    }

    /// Add a table to the list of available tables.
    ///
    /// - Parameter table: A String value.
    /// - Returns: The current Builder instance.
    public func add(table: String) -> Self {
      localizer.tables.append(table)
      return self
    }

    /// Replace the current tables.
    ///
    /// - Parameter table: A Sequence of Strings.
    /// - Returns: The current Builder instance.
    @discardableResult
    public func with<S>(tables: S) -> Self where S: Sequence, S.Element == String {
      localizer.tables = tables.map({$0})
      return self
    }
  }
}

extension Localizer.Builder: BuilderType {
  public typealias Buildable = Localizer

  public func with(buildable: Buildable?) -> Self {
    if let buildable = buildable {
      return self
        .with(bundles: buildable.bundles)
        .with(tables: buildable.tables)
    } else {
      return self
    }
  }

  public func build() -> Buildable {
    return localizer
  }
}
