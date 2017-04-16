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
    fileprivate var scheduler = TestScheduler(initialClock: 0)
    
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
    }
    
    func test_subjectOnNext_shouldEmitCorrectValues() {
        // Setup
        let subject1 = PublishSubject<Any>()
        let subject2 = PublishSubject<Any>()
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
        
        scheduler.start()
        
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
        
        let observer = scheduler.createObserver(Int.self)
        let array = [2, 4, 6, 8, 10, 7, 120]
        let firstOddIndex = array.index(where: Int.isOdd)!
        
        // When
        _ = observable.subscribe(observer)
        array.forEach(subject.onNext)
        scheduler.start()
        
        // Then
        let events = observer.events
        let nexts = events[0..<firstOddIndex]
        let errors = events[firstOddIndex]
        XCTAssertEqual(events.count, firstOddIndex + 1)
        XCTAssertEqual(nexts.flatMap({$0.value.element}).count, nexts.count)
        XCTAssertNotNil(errors.value.error)
    }
    
    func test_createWithForEach_shouldCreateMultipleStreams() {
        // Setup
        let array = [1, 2, 3, 4, 5]
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
        
        scheduler.start()
        
        // Then
        let events = observer.events
        
        let next = events[0..<events.count - 1].flatMap({
            $0.value.element as? Int
        })
        
        XCTAssertEqual(next, array)
    }
    
    func test_doOnMethods_shouldSucceed() {
        // Setup
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
        
        scheduler.start()
        
        // Then
    }
    
    func test_throwIfEmpty_shouldSucceed() {
        // Setup
        let observer = scheduler.createObserver(Any.self)
        
        // When
        _ = Observable.empty()
            .throwIfEmpty("Empty error")
            .subscribe(observer)
        
        scheduler.start()
        
        // Then
        XCTAssertNotNil(observer.events[0].value.error)
    }
    
    func test_catchSwitchToEmpty_shouldSucceed() {
        // Setup
        let observer = scheduler.createObserver(Any.self)
        
        // When
        _ = Observable.error("Error")
            .catchSwitchToEmpty()
            .subscribe(observer)
        
        scheduler.start()
        
        // Then
        let event = observer.events[0].value
        XCTAssertNil(event.element)
        XCTAssertNil(event.error)
    }
    
    func test_mapIfToOtherType_shouldSucceed() {
        // Setup
        let observer = scheduler.createObserver(String.self)
        let array: [Int] = [1, 2, 3, 4]
        
        // When
        _ = Observable.from(array)
            .mapIf(Int.isEven,
                   thenReturn: {_ in "Even"},
                   elseReturn: {_ in "Odd"})
            .subscribe(observer)
        
        scheduler.start()
        
        // Then
        let events = observer.events
        let values = events.flatMap({$0.value.element})
        
        XCTAssertEqual(
            values.filter({$0 == "Even"}).count,
            array.filter(Int.isEven).count
        )
        
        XCTAssertEqual(
            values.filter({$0 == "Odd"}).count,
            array.filter(Int.isOdd).count
        )
    }
    
    func test_mapIfToSameType_shouldSucceed() {
        // Setup
        let observer = scheduler.createObserver(Int.self)
        let array: [Int] = [1, 2, 3, 4]
        
        // When
        _ = Observable.from(array)
            .if(Int.isEven, thenReturn: {$0 + 1})
            .subscribe(observer)
        
        scheduler.start()
        
        // Then
        let events = observer.events
        let values = events.flatMap({$0.value.element})
        
        XCTAssertEqual(values.filter(Int.isOdd).count, array.count)
    }
    
    func test_flatMapToSameType_shouldSucceed() {
        // Setup
        let observer = scheduler.createObserver(Int.self)
        let array: [Int] = [1, 2, 3, 4]
        
        // When
        _ = Observable<Int>.from(array)
            .if(Int.isEven,
                then: Observable.just,
                else: {_ in Observable.empty()})
            .subscribe(observer)
        
        scheduler.start()
        
        // Then
        let events = observer.events
        let values = events.flatMap({$0.value.element})
        XCTAssertEqual(values.count, array.filter(Int.isEven).count)
    }
    
    func test_flatMapToOtherType_shouldSucceed() {
        // Setup
        let observer = scheduler.createObserver(String.self)
        let array: [Int] = [1, 2, 3, 4]
        
        // When
        _ = Observable.from(array)
            .flatMapIf(Int.isEven,
                       then: {_ in Observable.just("Even")},
                       else: {_ in Observable.just("Odd")})
            .subscribe(observer)
        
        scheduler.start()
        
        // Then
        let events = observer.events
        let values = events.flatMap({$0.value.element})
        let evens = array.filter(Int.isEven)
        let odds = array.filter(Int.isOdd)
        XCTAssertEqual(values.filter({$0 == "Even"}).count, evens.count)
        XCTAssertEqual(values.filter({$0 == "Odd"}).count, odds.count)
    }
    
    func test_castToWrongType_shouldThrow() {
        // Setup
        let observer = scheduler.createObserver(String.self)
        
        // When
        _ = Observable.just(1)
            .cast(to: String.self)
            .subscribe(observer)
        
        scheduler.start()
        
        // Then
        let events = observer.events
        let error = events.first!.value.error
        XCTAssertNotNil(error)
    }
    
    func test_castToCorrectType_shouldSucceed() {
        // Setup
        let observer = scheduler.createObserver(Any.self)
        
        // When
        _ = Observable.just("Test")
            .cast(to: Any.self)
            .subscribe(observer)
        
        scheduler.start()
        
        // Then
        let events = observer.events
        let next = events.first!.value.element
        XCTAssertNotNil(next)
        XCTAssertEqual(next as! String, "Test")
    }
    
    func test_ofTypeWrongType_shouldDoNothing() {
        // Setup
        let observer = scheduler.createObserver(String.self)
        
        // When
        _ = Observable.just(1)
            .ofType(String.self)
            .subscribe(observer)
        
        scheduler.start()
        
        // Then
        let events = observer.events
        let completed = events.first!.value.event
        XCTAssertTrue(completed == Event<String>.completed)
    }
    
    func test_ofTypeCorrectType_shouldSucceed() {
        // Setup
        let observer = scheduler.createObserver(Any.self)
        
        // When
        _ = Observable.just("Test")
            .cast(to: Any.self)
            .subscribe(observer)
        
        scheduler.start()
        
        // Then
        let events = observer.events
        let next = events.first!.value.element
        XCTAssertNotNil(next)
        XCTAssertEqual(next as! String, "Test")
    }
}
