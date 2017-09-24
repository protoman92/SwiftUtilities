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
    /// - Parameter s: Base.Stat instance.
    /// - Returns: An Observable instance.
    public func run(_ s: Base.Stat) -> Observable<StatePair<Base.Stat,Base.Val>> {
        return base.asState().tryRun(s).rx.get()
    }
}
