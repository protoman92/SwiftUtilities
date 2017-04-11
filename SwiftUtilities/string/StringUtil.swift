//
//  StringUtil.swift
//  Sellfie
//
//  Created by Hai Pham on 3/12/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

import Foundation
import UIKit

extension String: CustomComparisonProtocol {
    func equals(object: String?) -> Bool {
        return object == self
    }
}

extension String {
    
    /// Check if the current String is an email.
    var isEmail: Bool {
        return range(
            of: "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:.[a-z0-9!#$%&'*+/=?^_`{|}~-]" +
            "+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9" +
            "-]*[a-z0-9])?",
            options: .regularExpression) != nil
    }
    
    /// Check if the current String is not empty.
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    /// Localize the current String.
    var localized: String {
        let value = NSLocalizedString(self,
                                      tableName: "CommonLocalizable",
                                      comment: "")
        
        return NSLocalizedString(self, value: value, comment: "")
    }
    
    /// Underline the current String.
    var underlined: NSAttributedString {
        let attributes = [
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleDouble.rawValue
        ]
        
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    /// Localize the current String with a format.
    ///
    /// - Parameter args: Format parameters.
    /// - Returns: A localized String.
    func localize(_ args: CVarArg...) -> String {
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
    func replacingOccurrences(of characters: CharacterSet,
                              with string: String) -> String {
        return components(separatedBy: characters).joined(separator: string)
    }
}


extension String {
    struct Formatter {
        static let instance = NumberFormatter()
    }
    
    var doubleValue: Double? {
        return Formatter.instance.number(from: self)?.doubleValue
    }
    
    var integerValue: Int? {
        return Formatter.instance.number(from: self)?.intValue
    }
    
    var isDouble: Bool {
        return doubleValue != nil
    }
    
    var isInteger: Bool {
        return integerValue != nil
    }
}

extension String {
    init?(hexadecimalString hex: String) {
        guard let data = NSMutableData(hexadecimalString: hex) else {
            return nil
        }
        
        self.init(data: data as Data, encoding: .utf8)
    }
    
    var hexadecimalString: String? {
        return data(using: .utf8)?.hexadecimalString
    }
    
    func api() -> String? {
        return String(hexadecimalString: self)
    }
}

extension NSMutableData {
    convenience init?(hexadecimalString hex: String) {
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

extension Data {
    var hexadecimalString: String {
        return map{String(format: "%02x", $0)}.joined()
    }
}
