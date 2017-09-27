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
        //// Setup
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
        //// Setup
        let r1 = Reader<Int,Int>({$0 * 2})
        let r2 = Reader<Int,Int>({$0 * 3})
        let z1 = r1.zip(with: r2, {$0.0 * $0.1})
        
        let r3 = Reader<Double,Double>({$0 * 5})
        let z2 = r1.zip(with: r3, {Double($0.0) + $0.1})
        let r4 = Reader<Int,Int>.zip({$0.sum}, r1, r2, z1)
        
        /// When & Then
        for i in 0..<1000 {
            XCTAssertEqual(try z1.run(i), i * i * 2 * 3)
            XCTAssertEqual(try z2.run((i, Double(i * 2))), Double(i * 2 + i * 2 * 5))
            XCTAssertEqual(try r4.run(i), i * 2 + i * 3 + i * i * 6)
        }
    }
    
    public func test_readerZipIgnoringErrors_shouldWork() {
        //// Setup
        let r1 = Reader<Int,Int>({_ in throw Exception("Error1") })
        let r2 = Reader<Int,Int>({_ in throw Exception("Error2") })
        let r3 = Reader<Int,Int>(eq)
        let r4 = Reader<Int,Int>({$0 * 2})
        let z1 = Reader<Int,Int>.zip([r1, r2, r3, r4], {$0.sum})
        let z2 = Reader<Int,Int>.zip({$0.sum}, ignoringErrors: r1, r2, r3, r4)
        
        /// When & Then
        for i in 0..<1000 {
            XCTAssertThrowsError(try z1.run(i))
            XCTAssertEqual(try z2.run(i), i + i * 2)
        }
    }
    
    public func test_readerModify_shouldWork() {
        //// Setup
        let r1 = Reader<Int,Double>(Double.init)
        let r2 = Reader<String,Int?>({Int($0)}).map({$0 ?? 0})
        let r12: Reader<Double,Double> = r1.modify(Int.init)
        let r22: Reader<Int,Int> = r2.modify(String.init)
        
        /// When & Then
        for _ in 0..<1000 {
            let random = Int.random(0, 10000)
            XCTAssertEqual(try r12.run(Double(random)), Double(random))
            XCTAssertEqual(try r22.run(random), random)
        }
    }
    
//    public func test_readerRxApply_shouldWork() {
//        //// Setup
//        let error = "Error!"
//        let disposeBag = DisposeBag()
//        let scheduler = TestScheduler(initialClock: 0)
//        let observer = scheduler.createObserver(Try<Int>.self)
//        let expect = expectation(description: "Should have completed")
//        
//        let r1 = Reader<Int,Observable<Int>>(Observable.just)
//        let r2 = Reader<Void,Observable<Int>>({Observable.error(error)})
//        
//        // Even if we throw Error here, the overloaded apply() method that
//        // is only available when the resulting Observable emits 
//        // TryConvertibleType ensures that said Error is wrapped in Try as well.
//        let r3 = Reader<Void,Observable<Try<Int>>>({ throw Exception(error) })
//        
//        /// When
//        Observable.merge(r1.rx.tryFlatRun(1000), r2.rx.tryFlatRun(), r3.rx.flatRun())
//            .doOnDispose(expect.fulfill)
//            .subscribe(observer)
//            .disposed(by: disposeBag)
//        
//        waitForExpectations(timeout: 5, handler: nil)
//        
//        /// Then
//        let elements = observer.nextElements()
//        XCTAssertEqual(elements.count, 3)
//        
//        let first = elements.first!
//        let second = elements[1]
//        let third = elements[2]
//        XCTAssertTrue(first.isSuccess)
//        XCTAssertEqual(first.value, 1000)
//        XCTAssertTrue(second.isFailure)
//        XCTAssertEqual(second.error!.localizedDescription, error)
//        XCTAssertTrue(third.isFailure)
//        XCTAssertEqual(third.error!.localizedDescription, error)
//    }
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
