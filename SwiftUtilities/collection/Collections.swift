//
//  Collections.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 1/13/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import GameKit

public extension Sequence {
    
    /// Get the first item that is an instance of a specified Type.
    ///
    /// - Parameter type: The Type to check for matching elements.
    /// - Returns: An element whose type is the specified Type.
    public func firstItem<T>(ofType type: T.Type) -> T? {
        for item in self {
            if item is T {
                return item as? T
            }
        }
        
        return nil
    }
    
    /// Check if all Element passes a condition.
    ///
    /// - Parameter condition: Closure condition.
    /// - Returns: A Bool value.
    /// - Throws: An Error rethrown by any condition closure call.
    public func all(_ condition: (Iterator.Element) throws -> Bool)
        rethrows -> Bool
    {
        for element in self {
            if try !condition(element) {
                return false
            }
        }
        
        return true
    }
    
    /// Check if any Element satisfies a condition.
    ///
    /// - Parameter condition: Closure condition.
    /// - Returns: A Bool value.
    /// - Throws: An Error rethrown by any condition closure call.
    public func any(_ condition: (Iterator.Element) throws -> Bool)
        rethrows -> Bool
    {
        return try self.filter(condition).count >= 1
    }
    
    /// Check if the current Sequence contains an element, according to a
    /// predicate.
    ///
    /// - Parameter where: A Bool predicate.
    /// - Returns: A Bool value.
    /// - Throws: If any of the predicate checks throws an Error, rethrow it.
    public func doesNotContain(where: (Iterator.Element) throws -> Bool)
        rethrows -> Bool
    {
        return try !contains(where: `where`)
    }
    
    /// Print each element in the current Sequence.
    ///
    /// - Parameter convert: An optional conversion closure.
    /// - Throws: If any conversion throws an Error, rethrow it.
    public func logEach(_ convert: ((Iterator.Element) throws -> Any)? = nil)
        rethrows
    {
        if let convert = convert {
            do { try map(convert).logEach() } catch {}
        } else {
            forEach(debugPrint)
        }
    }
}

public extension Sequence where Iterator.Element: Hashable {
    
    /// Check if the current Sequence contains an element.
    ///
    /// - Parameter item: The Element to be checked.
    /// - Returns: A Bool value.
    public func doesNotContain(_ item: Iterator.Element) -> Bool {
        return !contains(item)
    }
    
    /// Produce a randomly-ordered distinct Array of element.
    ///
    /// - Returns: An Array of Element.
    public func distinct() -> [Iterator.Element] {
        return Set<Iterator.Element>(self).map(eq)
    }
    
    /// Produce a distinct Array of element that retains the original order.
    ///
    /// - Returns: An Array of Element.
    public func orderedDistinct() -> [Iterator.Element] {
        var distinct: [Iterator.Element] = []
        
        for element in self {
            if distinct.doesNotContain(element) {
                distinct.append(element)
            }
        }
        
        return distinct
    }
}

public extension Array {
    
    /// Check if the current Array contains an element at an index, by checking 
    /// whether the index
    /// is larger than 0, and smalled than the Array's length.
    ///
    /// - Parameter index: The index to be inspected.
    /// - Returns: A Bool value.
    public func containsElement(at index: Int) -> Bool {
        return index >= 0 && index < count
    }
    
    /// Get an element at a specified index. We can use this instead of 
    /// subscript notation, which can throw an Exception if the index is out 
    /// of range.
    ///
    /// - Parameter index: The index to be inspected.
    /// - Returns: An optional element.
    public func element(at index: Int) -> Element? {
        return containsElement(at: index) ? self[index] : nil
    }
    
    /// Get an element that satisfies a certain condition.
    ///
    /// - Parameter predicate: Predicate closure to check element validity.
    /// - Returns: An optional element.
    public func elementSatisfying(_ predicate: (Element) -> Bool) -> Element? {
        guard let index = index(where: predicate) else {
            return nil
        }

        return element(at: index)
    }
    
    /// Get a randomized Array of elements from the current Array.
    ///
    /// - Parameter elementCount: The number of random elements to get.
    /// - Returns: An Array of elements.
    public func randomize(_ elementCount: Int) -> [Element] {
        let rand = GKRandomSource.sharedRandom()
        let shuffled = rand.arrayByShufflingObjects(in: self)
        let prefixed = shuffled.prefix(Swift.max(0, elementCount))
        return prefixed.flatMap({$0 as? Element})
    }
    
    /// Get a random Element from the current Array.
    ///
    /// - Returns: An Element instance.
    public func randomElement() -> Element? {
        return self.element(at: Int.random(0, count))
    }
    
    /// Create an Array of elements repeated for a certain number of times.
    /// However, instead of containing the same elements, this Array contains
    /// elements as created by a selector.
    ///
    /// - Parameters:
    ///   - selector: Closure selector to create an Element instance.
    ///   - times: The number of times to repeat the element creation.
    public init(repeating selector: (Int) throws -> Element, for times: Int) {
        self.init()
        let count = Swift.max(0, times)
        
        for i in 0..<count {
            do {try append(selector(i))}
            catch {}
        }
    }
}

public extension Collection {

    /// Check if the current Collection is not empty.
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}

public extension Dictionary {
    
    /// Update the current Dictionary with another Dictionary.
    ///
    /// - Parameter dict: The Dictionary to get entries from.
    public mutating func updateValues(from dict: [Key: Value]) {
        for (key, value) in dict {
            self.updateValue(value, forKey: key)
        }
    }
    
    /// Update the current Dictionary with another Dictionary and return the
    /// result.
    ///
    /// - Parameter dict: A Dictionary instance.
    /// - Returns: A Dictionary instance.
    public func updatingValues(_ dict: [Key : Value]) -> [Key : Value] {
        var result = self
        result.updateValues(from: dict)
        return result
    }
    
    /// Update the current Dictionary with a key and value and return the result.
    ///
    /// - Parameters:
    ///   - value: A Value instance.
    ///   - key: A Key instance.
    /// - Returns: A Dictionary instance.
    public func updatingValue(_ value: Value, _ key: Key) -> [Key : Value] {
        var result = self
        result.updateValue(value, forKey: key)
        return result
    }
}

/// Add two Dictionaries.
///
/// - Parameters:
///   - lhs: A Dictionary instance.
///   - rhs: A Dictionary instance.
/// - Returns: A Dictionary instance.
public func +<K,V>(_ lhs: [K : V], _ rhs: [K : V]) -> [K : V] {
    return lhs.updatingValues(rhs)
}

/// Add two Dictionaries.
///
/// - Parameters:
///   - lhs: A Dictionary instance.
///   - rhs: A Dictionary instance.
/// - Returns: A Dictionary instance.
public func +<K,V>(_ lhs: [K : Any], _ rhs: [K : V]) -> [K : Any] {
    return lhs + rhs
}

extension Array: IsInstanceType {}
extension Dictionary: IsInstanceType {}
