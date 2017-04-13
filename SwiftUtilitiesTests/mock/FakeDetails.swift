//
//  FakeDetails.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 4/13/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

/// Use this class to store mock/stub details, such as method call counts.
public class FakeDetails {
    fileprivate var methodCount: Int
    fileprivate var parameters: [Any]
    
    public var methodCallCount: Int {
        return methodCount
    }
    
    public var methodParameters: [Any] {
        return parameters
    }
    
    fileprivate init() {
        methodCount = 0
        parameters = []
    }
    
    /// Increment the method's call count.
    public func incrementMethodCount() {
        methodCount += 1
    }
    
    /// Add a parameter object. This is usually a tuple of arguments.
    ///
    /// - Parameter parameter: A parameter object.
    public func addParameters(_ parameter: Any) {
        parameters.append(parameter)
    }
    
    public class Builder {
        fileprivate let fake: FakeDetails
        
        fileprivate init() {
            fake = FakeDetails()
        }
        
        public func build() -> FakeDetails {
            return fake
        }
    }
}

public extension FakeDetails {
    public static func builder() -> Builder {
        return Builder()
    }
}

extension FakeDetails: FakeProtocol {
    public func reset() {
        methodCount = 0
        parameters.removeAll()
    }
}
