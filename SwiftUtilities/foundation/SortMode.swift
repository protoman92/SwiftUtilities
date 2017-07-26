//
//  SortMode.swift
//  SwiftMediaContentHandler
//
//  Created by Hai Pham on 6/26/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

/// Implement this protocol to provide sort keys.
public protocol SortModeType {
    
    /// Get the associated sort key.
    var sortKey: String { get }
}
