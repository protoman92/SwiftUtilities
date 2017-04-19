//
//  InputDataTest.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/19/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxTest
import RxSwift
import XCTest

class InputDataTest: XCTestCase {
    fileprivate var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    func test_inputDataAsObservable_shouldSucceed() {
        // Setup
        let observer = scheduler.createObserver(Any.self)
        
        var input1 = InputData.builder()
            .with(identifier: "Input1")
            .with(header: "Input1")
            .isRequired(true)
            .build()
        
        var input2 = InputData.builder()
            .with(identifier: "Input2")
            .with(header: "Input2")
            .isRequired(true)
            .build()
        
        var input3 = InputData.builder()
            .with(identifier: "Input3")
            .with(header: "Input3")
            .isRequired(false)
            .build()
        
        let inputs = [input1, input2, input3]
        
        // When
        _ = inputs.inputListeners()
            .logNext()
            .cast(to: Any.self)
            .subscribe(observer)
        
        input1.inputContent = ""
        input2.inputContent = ""
        input3.inputContent = ""
        input1.inputContent = "Test input 1"
        input2.inputContent = "Test input 2"
        input3.inputContent = "Test input 3"
        input1.inputContent = "Test input 1-1"
        input2.inputContent = "Test input 2-2"
        input3.inputContent = "Test input 3-3"
        
        // Then
        print(observer.events.count)
        print(inputs.allInputs())
    }
    
    func test_inputDataContentListener_shouldSucceed() {
        // Setup
        let observer = scheduler.createObserver(Any.self)
        let subject = PublishSubject<String>()
        
        let input1 = InputData.builder()
            .with(identifier: "Input1")
            .with(header: "Input1")
            .isRequired(true)
            .build()
        
        let input2 = InputData.builder()
            .with(identifier: "Input2")
            .with(header: "Input2")
            .isRequired(true)
            .build()
        
        let input3 = InputData.builder()
            .with(identifier: "Input3")
            .with(header: "Input3")
            .isRequired(false)
            .build()
        
        // When
        _ = subject
            .doOnNext(input1.onNext)
            .doOnNext(input2.onNext)
            .doOnNext(input3.onNext)
            .cast(to: Any.self)
            .subscribe(observer)
        
        subject.onNext("Test1")
        subject.onNext("Test2")
        subject.onNext("Test3")
        
        // Then
        print(observer.events)
    }
}
