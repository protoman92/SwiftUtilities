//
//  ThreadTest.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 4/19/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import RxTest
import XCTest

final class ThreadTest: XCTestCase {
    func test_synchronized_shouldSucceed() {
        // Setup
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Any.self)
        let subject = PublishSubject<Any>()
        let expect = expectation(description: "Should have received values")
        let endValue = 1000
        
        // When
        _ = subject.subscribe(observer)
        
        for i in 0..<endValue {
            // We execute in background thread to simulate concurrent
            // emission. Normally, a small number of concurrent emissions
            // should still work, but if we are calling onNext on a large
            // number of elements, a bad access error will be thrown without
            // synchronized.
            background {
                synchronized(subject) {
                    subject.onNext(i)
                    
                    if i == endValue - 1 {
                        expect.fulfill()
                    }
                }
            }
        }
        
        // Then
        waitForExpectations(timeout: 10, handler: nil)
        print(observer.events)
    }
}
