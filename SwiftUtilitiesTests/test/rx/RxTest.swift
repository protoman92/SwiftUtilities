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
    
    func test_subjectOnError_shouldTerminateImmediately() {
        // Setup
        let subject = PublishSubject<Int>()
        
        let observable = subject
            .asObservable()
            // Must flatMap into another Observable, or else throwIfEmpty will
            // not be called.
            .flatMap({val in Observable.just(val)
                .filter(Int.isEven)
                .throwIfEmpty("Error")
                .ifEmpty(default: 10)})
        
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)
        let array = [2, 4, 6, 8, 10, 7, 120]
        let firstOddIndex = array.index(where: Int.isOdd)!
        
        // When
        _ = observable.subscribe(observer)
        array.forEach(subject.onNext)
        
        // Then
        let events = observer.events
        print(events)
        let nexts = events[0..<firstOddIndex]
        let errors = events[firstOddIndex]
        XCTAssertEqual(events.count, firstOddIndex + 1)
        XCTAssertEqual(nexts.flatMap({$0.value.element}).count, nexts.count)
        XCTAssertNotNil(errors.value.error)
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
        
        let next = events[0..<events.count - 1].flatMap({
            $0.value.element as? Int
        })
        
        XCTAssertEqual(next, array)
    }
    
    func test_doOnMethods_shouldSucceed() {
        // Setup
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Any.self)
        
        // When
        _ = Observable.just(1)
            .flatMap({_ in Observable.error(Exception())})
            .doOnNext {_ in
                print("OnNext")
            }
            .doOnError {_ in
                print("OnError")
            }
            .doOnCompleted {
                print("OnCompleted")
            }
            .doOnSubscribe {
                print("OnSubscribe")
            }
            .doOnSubscribed {
                print("OnSubscribed")
            }
            .doOnDispose {
                print("OnDisposed")
            }
            .subscribe(observer)
        
        // Then
    }
    
    func test_throwIfEmpty_shouldSucceed() {
        // Setup
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Any.self)
        
        // When
        _ = Observable.empty()
            .throwIfEmpty("Empty error")
            .subscribe(observer)
        
        // Then
        XCTAssertNotNil(observer.events[0].value.error)
    }
    
    func test_catchSwitchToEmpty_shouldSucceed() {
        // Setup
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Any.self)
        
        // When
        _ = Observable.error("Error")
            .catchSwitchToEmpty()
            .subscribe(observer)
        
        // Then
        let event = observer.events[0].value
        XCTAssertNil(event.element)
        XCTAssertNil(event.error)
    }
}
