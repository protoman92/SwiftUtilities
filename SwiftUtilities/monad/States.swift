//
//  States.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/10/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxCocoa
import RxSwift

public extension Reactive where Base: StateConvertibleType {
    
    /// Run State and throw Error if encountered.
    ///
    /// - Parameter s: Base.S instance.
    /// - Returns: An Observable instance.
    public func run(_ s: Base.S) -> Observable<StatePair<Base.S,Base.A>> {
        return base.asState().tryRun(s).rx.get()
    }
}
