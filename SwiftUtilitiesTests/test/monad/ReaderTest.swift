//
//  ReaderTest.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/8/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxCocoa
import RxSwift
import RxTest
import XCTest
@testable import SwiftUtilities

public final class ReaderTest: XCTestCase {
    public func test_readerMonad_shouldWorkWithDifferentInjection() {
        // Setup
        let r1 = IntReader({$0 * 2})
        let r2 = Reader<Int,String>({$0.description})
        
        // When & Then
        XCTAssertEqual(try r1.applyOrThrow(1), 2)
        XCTAssertEqual(try r1.applyOrThrow(2), 4)
        XCTAssertEqual(try r2.applyOrThrow(1), "1")
        XCTAssertEqual(try r2.applyOrThrow(2), "2")
        XCTAssertEqual(try r2.map({Int($0)}).applyOrThrow(2), 2)
        XCTAssertEqual(try r1.flatMap({i in IntReader({$0 * i})}).applyOrThrow(2), 8)
        XCTAssertEqual(try r2.flatMap({i in IntReader(eq)}).applyOrThrow(2), 2)
    }
    
    public func test_readerZip_shouldWork() {
        // Setup
        let r1 = Reader<Int,Int>({$0 * 2})
        let r2 = Reader<Int,Int>({$0 * 3})
        let r3 = r1.zip(with: r2, {$0.0 * $0.1})
        
        // When & Then
        for i in 0..<1000 {
            XCTAssertEqual(try r3.applyOrThrow(i), i * i * 2 * 3)
        }
    }
    
    public func test_readerRxApply_shouldWork() {
        // Setup
        let error = "Error!"
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Try<Int>.self)
        let r1 = Reader<Int,Observable<Int>>(Observable.just)
        let r2 = Reader<Void,Observable<Int>>({Observable.error(error)})
        let r3 = Reader<Void,Observable<Try<Int>>>({Observable.error(error)})
        let expect = expectation(description: "Should have completed")
        
        // When
        Observable.merge(r1.rx.tryApply(1000), r2.rx.tryApply(), r3.rx.apply())
            .doOnCompleted(expect.fulfill)
            .subscribe(observer)
            .addDisposableTo(disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // Then
        let elements = observer.nextElements()
        XCTAssertEqual(elements.count, 3)
        
        let first = elements.first!
        let second = elements[1]
        let third = elements[2]
        XCTAssertTrue(first.isSuccess)
        XCTAssertEqual(first.value, 1000)
        XCTAssertTrue(second.isFailure)
        XCTAssertEqual(second.error!.localizedDescription, error)
        XCTAssertTrue(third.isFailure)
        XCTAssertEqual(third.error!.localizedDescription, error)
    }
}

fileprivate final class IntReader {
    fileprivate let f: (Int) throws -> Int
    
    init(_ f: @escaping (Int) throws -> Int) {
        self.f = f
    }
}

extension IntReader: ReaderType {
    func asReader() -> Reader<Int,Int> {
        return Reader(f)
    }
}
