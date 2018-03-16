//
//  Blocking.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 15/3/18.
//  Copyright © 2018 Holmusk. All rights reserved.
//

import RxBlocking
import RxSwift

public func waitOnMainThread(_ interval: TimeInterval) {
  _ = try? Observable<Int>
    .timer(interval, scheduler: MainScheduler.instance)
    .toBlocking()
    .first()
}
