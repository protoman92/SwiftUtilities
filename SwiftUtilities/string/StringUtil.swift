//
//  StringUtil.swift
//  Sellfie
//
//  Created by Hai Pham on 3/12/16.
//  Copyright © 2016 Swiften. All rights reserved.
//

import Foundation
import UIKit

extension String: CustomComparisonProtocol {
    public func equals(object: String?) -> Bool {
        return object == self
    }
}

extension String: IsInstanceType {}

public extension String {
    
    /// Check if the current String is an email.
    public var isEmail: Bool {
        return range(
            of: "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:.[a-z0-9!#$%&'*+/=?^_`{|}~-]" +
            "+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9" +
            "-]*[a-z0-9])?",
            options: .regularExpression) != nil
    }
    
    /// Check if the current String is not empty.
    public var isNotEmpty: Bool {
        return !isEmpty
    }
    
    /// Localize the current String.
    public var localized: String {
        let value = NSLocalizedString(self,
                                      tableName: "CommonLocalizable",
                                      comment: "")
        
        return NSLocalizedString(self, value: value, comment: "")
    }
    
    /// Underline the current String.
    public var underlined: NSAttributedString {
        let attributes = [
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleDouble.rawValue
        ]
        
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    /// Localize the current String with a format.
    ///
    /// - Parameter args: Format parameters.
    /// - Returns: A localized String.
    public func localize(_ args: CVarArg...) -> String {
        let localized = NSLocalizedString(self,
                                          tableName: "CommonLocalizable",
                                          comment: "")
        
        let format = NSLocalizedString(self, value: localized, comment: "")
        return String(format: format, arguments: args)
    }
    
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
    public struct Formatter {
        static let instance = NumberFormatter()
    }
    
    /// Convert the current String into a Double.
    public var doubleValue: Double? {
        return Formatter.instance.number(from: self)?.doubleValue
    }
    
    /// Convert the current String into an Int.
    public var integerValue: Int? {
        return Formatter.instance.number(from: self)?.intValue
    }
    
    /// Check if the current String is convertible to a Double.
    public var isDouble: Bool {
        return doubleValue != nil
    }
    
    /// Check if the current String is convertible to an Int.
    public var isInteger: Bool {
        return integerValue != nil
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
        let characters = hex.characters
        let count = characters.count
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
