//
//  ReactiveTest.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 4/13/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import RxTest
import XCTest
@testable import SwiftUtilities

public final class ReactiveTest: XCTestCase {
  fileprivate var timeout: TimeInterval = 1000
  fileprivate var disposeBag: DisposeBag!
  fileprivate var scheduler: TestScheduler!

  override public func setUp() {
    disposeBag = DisposeBag()
    scheduler = TestScheduler(initialClock: 0)
  }

  public func test_publisherOnError_shouldWork() {
    /// Setup
    let publisher = PublishSubject<Int>()
    let observer = scheduler.createObserver(Int.self)

    /// When
    publisher.asObservable().subscribe(observer).disposed(by: disposeBag)
    publisher.onNext(1)
    publisher.onNext(2)
    publisher.onNext(3)
    publisher.onError(Exception("Error!"))
    publisher.onNext(4)

    /// Then
    let nextElements = observer.nextElements()
    XCTAssertFalse(nextElements.contains(4))
  }

  public func test_createWithForEach_shouldCreateMultipleStreams() {
    /// Setup
    let array = [1, 2, 3, 4, 5]
    let observer = scheduler.createObserver(Any.self)

    /// When
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
      .disposed(by: disposeBag)

    /// Then
    let events = observer.events

    let next = events[0..<events.count - 1].flatMap({
      $0.value.element as? Int
    })

    XCTAssertEqual(next, array)
  }

  public func test_doOnMethods_shouldWork() {
    /// Setup
    let observer = scheduler.createObserver(Any.self)

    /// When
    Observable.just(1)
      .flatMap({_ in Observable.error(Exception())})
      .doOnNext {_ in print("OnNext")}
      .doOnError {_ in print("OnError")}
      .doOnCompleted {print("OnCompleted")}
      .doOnSubscribe {print("OnSubscribe")}
      .doOnSubscribed {print("OnSubscribed")}
      .doOnDispose {print("OnDisposed")}
      .subscribe(observer)
      .disposed(by: disposeBag)
  }

  public func test_catchReturnWithSelector_shouldWork() {
    /// Setup
    let message = "Empty error"
    let observer = scheduler.createObserver(String.self)

    /// When
    Observable.empty()
      .errorIfEmpty("Empty error")
      .catchErrorJustReturn({$0.localizedDescription})
      .subscribe(observer)
      .disposed(by: disposeBag)

    /// Then
    let nextElement = observer.nextElements().first!
    XCTAssertEqual(nextElement, message)
  }

  public func test_throwIfEmpty_shouldWork() {
    /// Setup
    let observer = scheduler.createObserver(Any.self)

    /// When
    Observable.empty()
      .errorIfEmpty("Empty error")
      .subscribe(observer)
      .disposed(by: disposeBag)

    /// Then
    XCTAssertNotNil(observer.events[0].value.error)
  }

  public func test_castToWrongType_shouldThrow() {
    /// Setup
    let observer = scheduler.createObserver(String.self)

    /// When
    Observable.just(1)
      .cast(to: String.self)
      .subscribe(observer)
      .disposed(by: disposeBag)

    /// Then
    let events = observer.events
    let error = events.first!.value.error
    XCTAssertNotNil(error)
  }

  public func test_castToCorrectType_shouldWork() {
    /// Setup
    let observer = scheduler.createObserver(Any.self)

    /// When
    Observable.just("Test")
      .cast(to: Any.self)
      .subscribe(observer)
      .disposed(by: disposeBag)

    /// Then
    let events = observer.events
    let next = events.first!.value.element
    XCTAssertNotNil(next)
    XCTAssertEqual(next as! String, "Test")
  }

  public func test_ofTypeWrongType_shouldDoNothing() {
    /// Setup
    let observer = scheduler.createObserver(String.self)

    /// When
    Observable.just(1)
      .ofType(String.self)
      .subscribe(observer)
      .disposed(by: disposeBag)

    /// Then
    let events = observer.events
    let completed = events.first!.value.event
    XCTAssertTrue(completed == Event<String>.completed)
  }

  public func test_ofTypeCorrectType_shouldWork() {
    /// Setup
    let observer = scheduler.createObserver(Any.self)

    /// When
    Observable.just("Test")
      .cast(to: Any.self)
      .subscribe(observer)
      .disposed(by: disposeBag)

    /// Then
    let events = observer.events
    let next = events.first!.value.element
    XCTAssertNotNil(next)
    XCTAssertEqual(next as! String, "Test")
  }

  public func test_range_shouldWork() {
    /// Setup
    let count = 100
    let observer = scheduler.createObserver(Int.self)

    /// When
    Observable<Int>
      .concat(
        Observable<Int>.range(inclusive: 0, exclusive: count),
        Observable<Int>.range(start: 0, count: count)
      )
      .subscribe(observer)
      .disposed(by: disposeBag)

    /// Then
    let nextElements = observer.nextElements()
    XCTAssertEqual(nextElements.count, count * 2)
  }

  public func test_flatMapSequence_shouldWork() {
    /// Setup
    let observer = scheduler.createObserver(Int.self)
    let expect = expectation(description: "Should have completed")
    let count = 1000
    let numbers = (0..<count).map({$0})

    /// When
    Observable.just(numbers)
      .flatMapSequence({$0})
      .doOnDispose(expect.fulfill)
      .subscribe(observer)
      .disposed(by: disposeBag)

    waitForExpectations(timeout: timeout, handler: nil)

    /// Then
    let nextElements = observer.nextElements()
    XCTAssertEqual(numbers.count, nextElements.count)
    XCTAssertTrue(numbers.all({nextElements.contains($0)}))
  }

  public func test_mapNonNilOrEmptyWithIfEmpty_shouldNotWorkForStream() {
    /// Setup
    let observer = scheduler.createObserver(Int.self)
    let objectStream = PublishSubject<(Int?, Int?, Int?)?>()
    let times = 10

    objectStream
      .mapNonNilOrEmpty({$0?.0})
      .ifEmpty(default: 0)
      .subscribe(observer)
      .disposed(by: disposeBag)

    /// When
    for _ in 0..<times {
      objectStream.onNext(nil)
    }

    /// Then
    let nextElements = observer.nextElements()
    XCTAssertEqual(nextElements.count, 0)
  }

  public func test_delayRetryWithFiniteRetry_shouldWork() {
    /// Setup
    let observer = scheduler.createObserver(Int.self)
    let expect = expectation(description: "Should have completed")
    let retries = 5
    let delay: TimeInterval = 0.5
    let retryScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    var previousTime = Date()
    var currentTry = 0
    var delays: [TimeInterval] = []

    /// When
    Observable<Int>.error("Error!")
      .doOnError({_ in
        // Skip the first error in order to take into account only the
        // retries.
        if currentTry >= 1 {
          let currentTime = Date()
          let difference = currentTime.timeIntervalSince(previousTime)
          delays.append(difference)
          previousTime = currentTime
        }

        currentTry += 1
      })
      .delayRetry(retries: retries, delay: delay, scheduler: retryScheduler)
      .doOnDispose(expect.fulfill)
      .subscribe(observer)
      .disposed(by: disposeBag)

    waitForExpectations(timeout: 1000, handler: nil)

    /// Then
    XCTAssertEqual(currentTry, retries + 1)
    delays.forEach({XCTAssertLessThan(abs($0 - delay), 0.2)})
  }

  public func test_delayRetryWithStopNotification_shouldWork() {
    /// Setup
    let observer = scheduler.createObserver(Int.self)
    let expect = expectation(description: "Should have completed")
    let retryScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    let retries = Int.max
    let delay: TimeInterval = 1000
    let terminateDelay: TimeInterval = 2
    let terminateObs = Observable<Int>.timer(terminateDelay, scheduler: retryScheduler).map(toVoid)
    let currentTime = Date()
    var waitInterval: TimeInterval = 0

    /// When
    Observable<Int>.error("Error")
      .delayRetry(retries: retries,
                  delay: delay,
                  scheduler: retryScheduler,
                  terminateObs: terminateObs)
      .doOnError({_ in waitInterval = Date().timeIntervalSince(currentTime)})
      .doOnDispose(expect.fulfill)
      .subscribe(observer)
      .disposed(by: disposeBag)

    waitForExpectations(timeout: 1000, handler: nil)

    /// Then
    XCTAssertTrue(waitInterval < delay)
  }

  public func test_timeDifference_shouldWork() {
    /// Setup
    let observer = scheduler.createObserver(TimeInterval.self)
    let expect = expectation(description: "Should have completed")
    let interval: TimeInterval = 0.1
    let takeCount = 20

    /// When
    Observable<Int>.interval(interval, scheduler: MainScheduler.instance)
      .map({$0 + 1}).startWith(0)
      .timeDifference()
      .skip(1)
      .map({$0.difference})
      .take(takeCount)
      .doOnDispose(expect.fulfill)
      .subscribe(observer)
      .disposed(by: disposeBag)

    waitForExpectations(timeout: timeout, handler: nil)

    /// Then
    let nextElements = observer.nextElements()
    XCTAssertEqual(nextElements.count, takeCount)
    XCTAssertTrue(nextElements.all({(($0 - interval) / interval) < 0.1}))
  }

  public func test_trackInitial_shouldWork() {
    /// Setup
    let observer = scheduler.createObserver(Int.self)
    let times = 10000
    let stream = PublishSubject<Int>()
    let initial = 1

    stream.distinctInitialEmission()
      .subscribe(observer)
      .disposed(by: disposeBag)

    stream.onNext(initial)

    /// When
    for _ in 0..<times {
      stream.onNext(Int.random(2, 100000))
    }

    /// Then
    let nextElements = observer.nextElements()
    XCTAssertTrue(!nextElements.isEmpty)
    XCTAssertEqual(nextElements.count, 1)
    XCTAssertTrue(nextElements.all({$0 == initial}))
  }
}
