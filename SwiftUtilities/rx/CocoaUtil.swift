//
//  CocoaUtil.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/9/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxCocoa
import RxSwift

public extension Reactive where Base == URLSession {
    
    /// Same as data(request:), but wrap the result in a Try.
    ///
    /// - Parameter request: A URLRequest instance.
    /// - Returns: An Observable instance.
    public func tryData(request: URLRequest) -> Observable<Try<Data>> {
        return data(request: request)
            .map(Try<Data>.success)
            .catchErrorJustReturn(Try<Data>.failure)
    }
}
