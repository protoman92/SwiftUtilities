//
//  FakeDetails.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 4/13/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

/// Use this class to store mock/stub details, such as method call counts.
public class FakeDetails {
    fileprivate var count: Int
    fileprivate var name: String
    fileprivate var parameters: [Any?]
    
    public var methodCount: Int {
        return count
    }
    
    public var methodName: String {
        return name
    }
    
    public var methodParameters: [Any?] {
        return parameters
    }
    
    public var methodCalled: Bool {
        return methodCount > 0
    }
    
    public var methodNotCalled: Bool {
        return methodCount == 0
    }
    
    fileprivate init() {
        count = 0
        name = ""
        parameters = []
    }
    
    /// Increment the method's call count.
    public func incrementMethodCount() {
        count += 1
    }
    
    /// Add a parameter object. This is usually a tuple of arguments.
    ///
    /// - Parameter parameter: A parameter object.
    public func addParameters(_ parameter: Any?) {
        parameters.append(parameter)
    }
    
    /// Call this when a fake's method is called. We can detect the method's
    /// name and store it, instead of manually setting methodName (which can
    /// be troublesome if the method changes name later). However, it is
    /// crucial that this is called in the right place.
    ///
    /// - Parameters:
    ///   - method: The called method's name.
    ///   - parameters: The parameters with which the method was called.
    public func onMethodCalled(_ method: String = #function,
                               withParameters parameters: Any?) {
        name = method
        incrementMethodCount()
        addParameters(parameters)
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
        count = 0
        name = ""
        parameters.removeAll()
    }
}

public protocol FakeDetailProtocol {
    var methodName: String { get }
    
    var methodCount: Int { get }
    
    var methodParameters: [Any?] { get }
}

extension FakeDetails: FakeDetailProtocol {}
