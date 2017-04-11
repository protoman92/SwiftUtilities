//
//  CollectionUtil.swift
//  Heartland Chefs
//
//  Created by Hai Pham on 1/13/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import GameKit

protocol CustomComparisonProtocol {
    associatedtype E
    
    func equals(object: E?) -> Bool
}

extension Array {
    
    /// Check if the current Array contains an element at an index, by checking 
    /// whether the index
    /// is larger than 0, and smalled than the Array's length.
    ///
    /// - Parameter index: The index to be inspected.
    /// - Returns: A Bool value.
    func containsElement(at index: Int) -> Bool {
        return index >= 0 && index < count
    }
    
    /// Get an element at a specified index. We can use this instead of 
    /// subscript notation, which can throw an Exception if the index is out 
    /// of range.
    ///
    /// - Parameter index: The index to be inspected.
    /// - Returns: An optional element.
    func element(at index: Int) -> Element? {
        if containsElement(at: index) {
            return self[index]
        }
        
        return nil
    }
    
    /// Get an element that satisfies a certain condition.
    ///
    /// - Parameter predicate: Predicate closure to check element validity.
    /// - Returns: An optional element.
    func elementSatisfying(_ predicate: (Element) -> Bool) -> Element? {
        guard let index = index(where: predicate) else {
            return nil
        }
        
        return element(at: index)
    }
    
    /// Get a randomized Array of elements from the current Array.
    ///
    /// - Parameter elementCount: The number of random elements to get.
    /// - Returns: An Array of elements.
    func randomize(_ elementCount: Int) -> [Any] {
        let rand = GKRandomSource.sharedRandom()
        let shuffled = rand.arrayByShufflingObjects(in: self)
        let prefixed = shuffled.prefix(Swift.max(0, elementCount))
        return prefixed.map({$0})
    }
    
    /// Get the first item that is an instance of a specified Type.
    ///
    /// - Parameter type: The Type to check for matching elements.
    /// - Returns: An element whose type is the specified Type.
    func firstItem<T>(ofType type: T.Type) -> T? {
        for item in self {
            if item is T {
                return item as? T
            }
        }
        
        return nil
    }
}

extension Array where Element: CustomComparisonProtocol, Element == Element.E {
    
    /// Append an unique element.
    ///
    /// - Parameter element: An element to be appended.
    /// - Returns: A Bool value, true if the element was successfully appended.
    @discardableResult
    mutating func append(uniqueElement element: Element) -> Bool {
        if !contains(where: {$0.equals(object: element)}) {
            append(element)
            return true
        }
        
        return false
    }
    
    /// Append a unique element, or replace an existing element with this
    /// element.
    ///
    /// - Parameter element: The element to be appended or replaced.
    /// - Returns: An Int value for the total number of appended elements.
    @discardableResult
    mutating func appendOrReplace(uniqueElement element: Element) -> Int {
        if let index = index(where: {$0.equals(object: element)}) {
            self[index] = element
            return 0
        } else {
            append(element)
            return 1
        }
    }
    
    /// Append an Array uniquely, i.e. only unique elements.
    ///
    /// - Parameter data: The Array to be appended.
    /// - Returns: An Int value for the total number of appended elements.
    @discardableResult
    mutating func append(uniqueContentsOf data: [Element]) -> Int {
        var added = 0
        
        for item in data where !contains(where: {$0.equals(object: item)}) {
            append(item)
            added += 1
        }
        
        return added
    }
    
    /// Append an Array uniquely, or replace existing elements if applicable.
    ///
    /// - Parameter data: The Array to be appended.
    /// - Returns: An Int value for the total number of appended elements.
    @discardableResult
    mutating func appendOrReplace(uniqueContentsOf data: [Element]) -> Int {
        var added = 0
        
        for item in data {
            added += appendOrReplace(uniqueElement: item)
        }
        
        return added
    }
    
    /// Check if an element is found in the current Array.
    ///
    /// - Parameter element: The element to be inspected for existence.
    /// - Returns: A Bool value.
    func contains(element: Element) -> Bool {
        return contains(where: {$0.equals(object: element)})
    }
    
    /// Check if the current Array is deeply equal to another Array.
    ///
    /// - Parameter data: The Array to be checked for equality.
    /// - Returns: A Bool value.
    func equals(to data: [Element]) -> Bool {
        guard self.count == data.count else {
            return false
        }
        
        for item in self {
            if !data.contains(where: {$0.equals(object: item)}) {
                return false
            }
        }
        
        return true
    }
    
    /// Check if the current Array is a subset of another Array.
    ///
    /// - Parameter data: The Array to be checked against.
    /// - Returns: A Bool value.
    func isSubset(of data: [Element]) -> Bool {
        guard self.count < data.count else {
            return false
        }
        
        for item in self {
            if !data.contains(where: {$0.equals(object: item)}) {
                return false
            }
        }
        
        return true
    }
    
    /// Check if the current Array is a superset of another Array.
    ///
    /// - Parameter data: The Array to be checked against.
    /// - Returns: A Bool value.
    func isSuperset(of data: [Element]) -> Bool {
        return data.isSubset(of: self)
    }
    
    /// Check if the current Array is a subset of, or equal to, another Array.
    ///
    /// - Parameter data: The Array to be checked against.
    /// - Returns: A Bool value.
    func isSubsetOfOrEqualsTo(_ data: [Element]) -> Bool {
        guard self.count <= data.count else {
            return false
        }
        
        for item in self {
            if !data.contains(where: {$0.equals(object: item)}) {
                return false
            }
        }
        
        return true
    }
    
    /// Check if the current Array is a superset of, or equal to, another Array.
    ///
    /// - Parameter data: The Array to be checked against.
    /// - Returns: A Bool value.
    func isSupersetOfOrEqualsTo(_ data: [Element]) -> Bool {
        return data.isSubsetOfOrEqualsTo(self)
    }
    
    /// Filter out elements that match a predicate, and return a new Array
    /// with the rest of the elements.
    ///
    /// - Parameter predicate: The predicate to check for validity.
    /// - Returns: A new Array with unfiltered elements.
    func filteringOut(where predicate: (Element) -> Bool) -> [Element] {
        let filtered = self.filter(predicate)
        return removingContents(of: filtered)
    }
    
    /// Remove an object at a specified index.
    ///
    /// - Parameter object: The element to be removed.
    /// - Returns: An optional index at which the object to be removed is found.
    @discardableResult
    mutating func remove(object: Element) -> Int? {
        guard let index = index(where: {$0.equals(object: object)}) else {
            return nil
        }
        
        self.remove(at: index)
        return index
    }
    
    /// Remove contents of another Array.
    ///
    /// - Parameter array: The Array whose elements will be removed.
    ///
    /// - Returns: The number of elements that was removed.
    @discardableResult
    mutating func removeContents(of array: [Element]) -> Int {
        var removed = 0
        
        for element in array where remove(object: element) != nil {
            removed += 1
        }
        
        return removed
    }
    
    /// Remove contents of another Array, and return a modified Array with
    /// the rest of the elements.
    ///
    /// - Parameter array: <#array description#>
    /// - Returns: <#return value description#>
    func removingContents(of array: [Element]) -> [Element] {
        var copy = self
        copy.removeContents(of: array)
        return copy
    }
}

extension Collection {

    /// Check if the current Collection is not empty.
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension Dictionary {
    
    /// Check if the current Dictionary is not empty.
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    /// Update the current Dictionary with another Dictionary.
    ///
    /// - Parameter dict: The Dictionary to get entries from.
    mutating func updateValues(from dict: [Key : Value]) {
        for (key, value) in dict {
            self.updateValue(value, forKey: key)
        }
    }
}