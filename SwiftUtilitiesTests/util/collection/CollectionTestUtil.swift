//
//  CollectionTestUtil.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 4/20/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

public extension Array {
    
    /// Get a random Element from the current Array.
    ///
    /// - Returns: An Element instance.
    public func randomElement() -> Element? {
        let index = Int.random(0, count)
        return self.element(at: index)
    }
}
