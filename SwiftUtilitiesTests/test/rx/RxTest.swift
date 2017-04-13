//
//  RxTest.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 4/13/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import RxTest
import XCTest

class RxTest: XCTestCase {
    func test_subjectOnNext_shouldEmitCorrectValues() {
        // Setup
        let subject1 = PublishSubject<Any>()
        let subject2 = PublishSubject<Any>()
        let scheduler = TestScheduler(initialClock: 0)
        let observer1 = scheduler.createObserver(Any.self)
        let observer2 = scheduler.createObserver(Any.self)
        
        // When
        _ = subject1.subscribe(observer1)
        _ = subject2.subscribe(observer1)
        _ = subject1.subscribe(observer2)
        _ = subject2.subscribe(observer2)
        
        subject1.onNext(1)
        subject1.onNext(2)
        subject1.onNext(3)
        subject2.onNext(4)
        subject2.onNext(5)
        subject2.onNext(6)
        
        // Then
        [observer1, observer2].forEach({
            let events = $0.events
            let onNext1 = events[0...2]
            let onNext2 = events[3...5]
            let next1 = onNext1.flatMap({$0.value.element as? Int})
            let next2 = onNext2.flatMap({$0.value.element as? Int})
            XCTAssertEqual(next1, [1, 2, 3])
            XCTAssertEqual(next2, [4, 5, 6])
        })
    }
    
    func test_createWithForEach_shouldCreateMultipleStreams() {
        // Setup
        let array = [1, 2, 3, 4, 5]
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Any.self)
        
        // When
        _ = Observable<Any>
            .create({observer in
                for (i, n) in array.enumerated() {
                    observer.onNext(n)
                    
                    if i == array.count - 1 {
                        observer.onCompleted()
                    }
                }
                
                return Disposables.create()
            })
            .subscribe(observer)
        
        // Then
        let events = observer.events
        let next = events[0..<events.count - 1].flatMap({$0.value.element as? Int})
        XCTAssertEqual(next, array)
    }
}
