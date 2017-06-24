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

final class RxTest: XCTestCase {
    fileprivate var disposeBag: DisposeBag!
    fileprivate var scheduler: TestScheduler!
    
    override func setUp() {
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    func test_createWithForEach_shouldCreateMultipleStreams() {
        // Setup
        let array = [1, 2, 3, 4, 5]
        let observer = scheduler.createObserver(Any.self)
        
        // When
        Observable<Any>
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
            .addDisposableTo(disposeBag)
        
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
        Observable.just(1)
            .flatMap({_ in Observable.error(Exception())})
            .doOnNext {_ in print("OnNext")}
            .doOnError {_ in print("OnError")}
            .doOnCompleted {print("OnCompleted")}
            .doOnSubscribe {print("OnSubscribe")}
            .doOnSubscribed {print("OnSubscribed")}
            .doOnDispose {print("OnDisposed")}
            .subscribe(observer)
            .addDisposableTo(disposeBag)
        
        // Then
    }
    
    func test_throwIfEmpty_shouldSucceed() {
        // Setup
        let observer = scheduler.createObserver(Any.self)
        
        // When
        Observable.empty()
            .throwIfEmpty("Empty error")
            .subscribe(observer)
            .addDisposableTo(disposeBag)
        
        // Then
        XCTAssertNotNil(observer.events[0].value.error)
    }
    
    func test_catchSwitchToEmpty_shouldSucceed() {
        // Setup
        let observer = scheduler.createObserver(Any.self)
        
        // When
        Observable.error("Error")
            .catchSwitchToEmpty()
            .subscribe(observer)
            .addDisposableTo(disposeBag)
        
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
        Observable.from(array)
            .mapIf(Int.isEven,
                   thenReturn: {_ in "Even"},
                   elseReturn: {_ in "Odd"})
            .subscribe(observer)
            .addDisposableTo(disposeBag)
        
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
        Observable.from(array)
            .if(Int.isEven, thenReturn: {$0 + 1})
            .subscribe(observer)
            .addDisposableTo(disposeBag)
        
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
        Observable<Int>.from(array)
            .if(Int.isEven,
                then: Observable.just,
                else: {_ in Observable.empty()})
            .subscribe(observer)
            .addDisposableTo(disposeBag)
        
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
        Observable.from(array)
            .flatMapIf(Int.isEven,
                       then: {_ in Observable.just("Even")},
                       else: {_ in Observable.just("Odd")})
            .subscribe(observer)
            .addDisposableTo(disposeBag)
        
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
        Observable.just(1)
            .cast(to: String.self)
            .subscribe(observer)
            .addDisposableTo(disposeBag)
        
        // Then
        let events = observer.events
        let error = events.first!.value.error
        XCTAssertNotNil(error)
    }
    
    func test_castToCorrectType_shouldSucceed() {
        // Setup
        let observer = scheduler.createObserver(Any.self)
        
        // When
        Observable.just("Test")
            .cast(to: Any.self)
            .subscribe(observer)
            .addDisposableTo(disposeBag)
        
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
        Observable.just(1)
            .ofType(String.self)
            .subscribe(observer)
            .addDisposableTo(disposeBag)
        
        // Then
        let events = observer.events
        let completed = events.first!.value.event
        XCTAssertTrue(completed == Event<String>.completed)
    }
    
    func test_ofTypeCorrectType_shouldSucceed() {
        // Setup
        let observer = scheduler.createObserver(Any.self)
        
        // When
        Observable.just("Test")
            .cast(to: Any.self)
            .subscribe(observer)
            .addDisposableTo(disposeBag)
        
        // Then
        let events = observer.events
        let next = events.first!.value.element
        XCTAssertNotNil(next)
        XCTAssertEqual(next as! String, "Test")
    }
    
    func test_staticIfSwitch_shouldSucceed() {
        // Setup
        let observer = scheduler.createObserver(Any.self)
        
        // When
        Observable<Int>
            .if({true}, then: {Observable.just(1)}, else: {Observable.just(2)})
            .subscribe(observer)
            .addDisposableTo(disposeBag)
        
        // Then
        XCTAssertEqual(observer.events.first!.value.element as! Int, 1)
    }
    
    func test_staticIfReturn_shouldSucceed() {
        // Setup
        let observer = scheduler.createObserver(Any.self)
        
        // When
        Observable<Int>
            .if({true}, thenReturn: {1}, elseReturn: {2})
            .subscribe(observer)
            .addDisposableTo(disposeBag)
        
        // Then
        XCTAssertEqual(observer.events.first!.value.element as! Int, 1)
    }
    
    func test_range_shouldSucceed() {
        // Setup
        let count = 100
        let observer = scheduler.createObserver(Int.self)
        
        // When
        Observable<Int>
            .concat(
                Observable<Int>.range(inclusive: 0, exclusive: count),
                Observable<Int>.range(start: 0, count: count)
            )
            .subscribe(observer)
            .addDisposableTo(disposeBag)
        
        // Then
        let nextElements = observer.nextElements()
        XCTAssertEqual(nextElements.count, count * 2)
    }
}
