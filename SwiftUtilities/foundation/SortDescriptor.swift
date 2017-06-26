//
//  SortDescriptor.swift
//  SwiftMediaContentHandler
//
//  Created by Hai Pham on 6/26/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import Foundation

/// Convenience NSSortDescriptor provider.
public struct SortDescriptor<T> {
    fileprivate var order: SortOrder
    fileprivate var mode: SortModeType?
    fileprivate var comparator: GenericComparator<T>?
    
    fileprivate init() {
        order = .ascending
    }
    
    /// Get the associated NSSortDescriptor instance.
    ///
    /// - Returns: A NSSortDescriptor instance.
    public func descriptor() -> NSSortDescriptor {
        let sortKey = mode?.sortKey
        let ascending = order == .ascending
        
        if let genericComparator = self.comparator {
            let comparator = toComparator(from: genericComparator)
            
            return NSSortDescriptor(key: sortKey,
                                    ascending: ascending,
                                    comparator: comparator)
        } else {
            return NSSortDescriptor(key: sortKey, ascending: ascending)
        }
    }
    
    /// Convert a GenericComparator to a Comparator.
    ///
    /// - Parameter comparator: A Generic Comparator instance.
    /// - Returns: A Comparator instance.
    fileprivate func toComparator(
        from comparator: @escaping GenericComparator<T>
    ) -> Comparator {
        return {
            if let item1 = $0 as? T, let item2 = $1 as? T {
                return comparator(item1, item2)
            } else {
                debugException("Invalid types for \($0) and \($1)")
                return ComparisonResult.orderedAscending
            }
        }
    }
    
    /// Builder class for SortDescriptor.
    public final class Builder<T> {
        private var descriptor: SortDescriptor<T>
        
        fileprivate init() {
            descriptor = SortDescriptor<T>()
        }
        
        /// Set the order instance.
        ///
        /// - Parameter order: A SortOrder instance.
        /// - Returns: The current Builder instance.
        @discardableResult
        public func with(order: SortOrder) -> Builder {
            descriptor.order = order
            return self
        }
        
        /// Set the mode instance.
        ///
        /// - Parameter mode: A SortModeType instance.
        /// - Returns: The current Builder instance.
        @discardableResult
        public func with(mode: SortModeType) -> Builder {
            descriptor.mode = mode
            return self
        }
        
        /// Set the comparator instance.
        ///
        /// - Parameter comparator: A Comparator instance.
        /// - Returns: The current Builder instance.
        @discardableResult
        public func with(comparator: @escaping GenericComparator<T>) -> Builder {
            descriptor.comparator = comparator
            return self
        }
        
        /// Get the descriptor instance.
        ///
        /// - Returns: A SortDescriptor instance.
        public func build() -> SortDescriptor<T> {
            return descriptor
        }
    }
}

public extension SortDescriptor {
    
    /// Get a Builder instance.
    ///
    /// - Returns: A Builder instance.
    public static func builder() -> Builder<T> {
        return Builder<T>()
    }
    
    /// Get a SortDescriptor with ascending sort mode.
    ///
    /// - Parameter mode: A SortModeType instance.
    /// - Returns: A SortDescriptor instance.
    public static func ascending<T>(for mode: SortModeType) -> SortDescriptor<T> {
        return SortDescriptor<T>.builder()
            .with(mode: mode)
            .with(order: .ascending)
            .build()
    }
    
    /// Get a SortDescriptor with descending sort mode.
    ///
    /// - Parameter mode: A SortModeType instance.
    /// - Returns: A SortDescriptor instance.
    public static func descending<T>(for mode: SortModeType) -> SortDescriptor<T> {
        return SortDescriptor<T>.builder()
            .with(mode: mode)
            .with(order: .descending)
            .build()
    }
}
