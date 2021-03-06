//
//  Strings.swift
//  Sellfie
//
//  Created by Hai Pham on 3/12/16.
//  Copyright © 2016 Swiften. All rights reserved.
//

extension String: IsInstanceType {}

public extension Character {

  /// Create a random Character. This is useful for creating random Strings.
  ///
  /// - Returns: A Character.
  public static func random() -> Character {
    let startingValue = Int(("a" as UnicodeScalar).value)
    let count = Int.randomBetween(0, 51)
    return Character(UnicodeScalar(count + startingValue)!)
  }
}

public extension String {

  /// Create a random String.
  ///
  /// - Parameter length: The length of the String to be created.
  /// - Returns: A String value.
  public static func random(withLength length: Int) -> String {
    return String((0..<length).map({_ in Character.random()}))
  }
}

public extension String {

  /// Replace occurrences of a String with a set of character types.
  ///
  /// - Parameters:
  ///   - characters: The character set to be replaced.
  ///   - string: The String to replace.
  /// - Returns: A String value.
  public func replacingOccurrences(of characters: CharacterSet,
                                   with string: String) -> String {
    return components(separatedBy: characters).joined(separator: string)
  }
}

public extension String {

  /// Localize a String based a a bundle and some table names. We sequentially
  /// check the localization from each table until a localized String that is
  /// different from the current String is generated.
  ///
  /// - Parameters:
  ///   - bundle: A Bundle instance.
  ///   - tables: Sequence of String.
  /// - Returns: A String value.
  public func localize<S>(_ bundle: Bundle, _ tables: S) -> String where
    S: Sequence, S.Element == String
  {
    for table in tables {
      let localized = NSLocalizedString(self,
                                        tableName: table,
                                        bundle: bundle,
                                        value: "",
                                        comment: "")

      if localized != self {
        return localized
      }
    }

    return NSLocalizedString(self, comment: "")
  }

  /// Localize with the default Bundle.
  ///
  /// - Parameter tables: Varargs of String.
  /// - Returns: A String value.
  public func localize<S>(_ tables: S) -> String where S: Sequence, S.Element == String {
    return localize(Bundle.main, tables)
  }

  /// Localize a String based a a bundle and some table names.
  ///
  /// - Parameters:
  ///   - bundle: A Bundle instance.
  ///   - tables: Sequence of String.
  /// - Returns: A String value.
  public func localize(_ bundle: Bundle, _ tables: String...) -> String {
    return localize(bundle, tables)
  }

  /// Localize with the default Bundle.
  ///
  /// - Parameter tables: Varargs of String.
  /// - Returns: A String value.
  public func localize(_ tables: String...) -> String {
    return localize(tables)
  }
}

public extension String {
  public init?(hexadecimalString hex: String) {
    guard let data = NSMutableData(hexadecimalString: hex) else {
      return nil
    }

    self.init(data: data as Data, encoding: .utf8)
  }

  public var hexadecimalString: String? {
    return data(using: .utf8)?.hexadecimalString
  }
}

public extension NSMutableData {
  public convenience init?(hexadecimalString hex: String) {
    let count = hex.count
    self.init(capacity: count / 2)

    do {
      let regex = try NSRegularExpression(pattern: "[0-9a-f]{1,2}",
                                          options: .caseInsensitive)

      let range = NSMakeRange(0, count)

      regex.enumerateMatches(in: hex, options: [], range: range) {
        match, flags, stop in
        guard let match = match else {
          return
        }

        let nsString = NSString(string: hex)
        let byteString = nsString.substring(with: match.range)
        var num = UInt8(byteString, radix: 16)
        self.append(&num, length: 1)
      }
    } catch {
      return nil
    }
  }
}

public extension Data {
  public var hexadecimalString: String {
    return map{String(format: "%02x", $0)}.joined()
  }
}
