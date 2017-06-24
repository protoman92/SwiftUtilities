//
//  MockTest.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 4/13/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import XCTest

final class MockTest: XCTestCase {
    let mc = MockClass()
    
    override func tearDown() {
        super.tearDown()
        mc.reset()
    }
    
    func test_mock_methodCalled_shouldBeCorrectlyRecorded() {
        // Test
        
        // When
        mc.mockMethod1(param1: 1)
        mc.mockMethod2(param1: "param1", param2: 2)
        
        // Then
        XCTAssertEqual(mc.fake_mockMethod1.methodCount, 1)
        XCTAssertEqual(mc.fake_mockMethod1.methodParameters[0] as! Int, 1)
        XCTAssertEqual(mc.fake_mockMethod2.methodCount, 1)
        XCTAssertTrue(mc.fake_mockMethod1.methodName.contains("mockMethod1"))
        XCTAssertTrue(mc.fake_mockMethod2.methodName.contains("mockMethod2"))
    }
}

class MockClass {
    let fake_mockMethod1: FakeDetails
    let fake_mockMethod2: FakeDetails
    
    init() {
        fake_mockMethod1 = FakeDetails.builder().build()
        fake_mockMethod2 = FakeDetails.builder().build()
    }
    
    func mockMethod1(param1: Int) {
        fake_mockMethod1.onMethodCalled(withParameters: param1)
    }
    
    func mockMethod2(param1: String, param2: Double) {
        fake_mockMethod2.onMethodCalled(withParameters: (param1, param2))
    }
    
    func reset() {
        fake_mockMethod1.reset()
        fake_mockMethod2.reset()
    }
}
