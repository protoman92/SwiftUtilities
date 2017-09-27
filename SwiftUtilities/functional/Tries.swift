//
//  Tries.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/8/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

extension Try: OptionalType {
    public typealias Value = A
    
    public static func just(_ value: Value) -> Optional<Value> {
        return Optional<Value>.some(value)
    }
    
    public static func nothing() -> Optional<Value> {
        return Optional<Value>.none
    }
}
