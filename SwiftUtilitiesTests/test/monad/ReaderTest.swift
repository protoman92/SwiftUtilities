//
//  ReaderTest.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/8/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import XCTest
@testable import SwiftUtilities

public final class ReaderTest: XCTestCase {
    public func test_readerMonad_shouldWorkWithDifferentInjection() {
        // Setup
        let r1 = IntReader({$0 * 2})
        let r2 = Reader<Int,String>({$0.description})
        
        // When & Then
        XCTAssertEqual(try r1.apply(1), 2)
        XCTAssertEqual(try r1.apply(2), 4)
        XCTAssertEqual(try r2.apply(1), "1")
        XCTAssertEqual(try r2.apply(2), "2")
        XCTAssertEqual(try r2.map({Int($0)}).apply(2), 2)
        XCTAssertEqual(try r1.flatMap({i in IntReader({$0 * i})}).apply(2), 8)
        XCTAssertEqual(try r2.flatMap({i in IntReader(eq)}).apply(2), 2)
    }
    
    public func test_readerZip_shouldWork() {
        // Setup
        let r1 = Reader<Int,Int>({$0 * 2})
        let r2 = Reader<Int,Int>({$0 * 3})
        let r3 = r1.zip(with: r2, {$0.0 * $0.1})
        
        // When & Then
        for i in 0..<1000 {
            XCTAssertEqual(try r3.apply(i), i * i * 2 * 3)
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
