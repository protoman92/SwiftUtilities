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
        /// Setup
        let r1 = IntReader({$0 * 2})
        let r2 = Reader<Int,String>({$0.description})
        
        /// When & Then
        XCTAssertEqual(try r1.run(1), 2)
        XCTAssertEqual(try r1.run(2), 4)
        XCTAssertEqual(try r2.run(1), "1")
        XCTAssertEqual(try r2.run(2), "2")
        XCTAssertEqual(try r2.map({Int($0)}).run(2), 2)
        XCTAssertEqual(try r1.flatMap({i in IntReader({$0 * i})}).run(2), 8)
        XCTAssertEqual(try r2.flatMap({i in IntReader(eq)}).run(2), 2)
    }
    
    public func test_readerZip_shouldWork() {
        /// Setup
        let r1 = Reader<Int,Int>({$0 * 2})
        let r2 = Reader<Int,Int>({$0 * 3})
        let r3 = r1.zip(with: r2, {$0.0 * $0.1})
        
        let r4 = Reader<Double,Double>({$0 * 5})
        let r5 = r1.zip(with: r4, {Double($0.0) + $0.1})
        
        /// When & Then
        for i in 0..<1000 {
            XCTAssertEqual(try r3.run(i), i * i * 2 * 3)
            XCTAssertEqual(try r5.run((i, Double(i * 2))), Double(i * 2 + i * 2 * 5))
        }
    }
    
    public func test_readerModify_shouldWork() {
        // Setup
        let r1 = Reader<Int,Double>(Double.init)
        let r2 = Reader<String,Int?>({Int($0)}).map({$0 ?? 0})
        let r12: Reader<Double,Double> = r1.modify(Int.init)
        let r22: Reader<Int,Int> = r2.modify(String.init)
        
        // When & Then
        for _ in 0..<1000 {
            let random = Int.random(0, 10000)
            XCTAssertEqual(try r12.run(Double(random)), Double(random))
            XCTAssertEqual(try r22.run(random), random)
        }
    }
    
    public func test_readerRxApply_shouldWork() {
        // Setup
        let error = "Error!"
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Try<Int>.self)
        let expect = expectation(description: "Should have completed")
        
        let r1 = Reader<Int,Observable<Int>>(Observable.just)
        let r2 = Reader<Void,Observable<Int>>({Observable.error(error)})
        
        // Even if we throw Error here, the overloaded apply() method that
        // is only available when the resulting Observable emits 
        // TryConvertibleType ensures that said Error is wrapped in Try as well.
        let r3 = Reader<Void,Observable<Try<Int>>>({ throw Exception(error) })
        
        /// When
        Observable.merge(r1.rx.tryFlatRun(1000), r2.rx.tryFlatRun(), r3.rx.flatRun())
            .doOnDispose(expect.fulfill)
            .subscribe(observer)
            .addDisposableTo(disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        /// Then
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
    
    public func test_measureReaderTime() {
        /// Setup
        let r1: Reader<String,Int> = Reader<Int,Int>({$0 * $0})
            .map(Double.init)
            .map(String.init)
            .flatMap({_ in Reader<Int,Int>(eq)})
            .modify({Int($0) ?? 0})
        
        let range = (0..<10000).map(eq).map(String.init)
        
        /// When & Then
        measure {
            range.forEach({_ = try? r1.run($0)})
        }
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
