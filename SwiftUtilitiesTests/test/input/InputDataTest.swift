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
        
        let input1 = InputData.builder()
            .with(input: MockInput.input1)
            .build()
        
        let input2 = InputData.builder()
            .with(input: MockInput.input2)
            .build()
        
        let input3 = InputData.builder()
            .with(input: MockInput.input3)
            .build()
        
        let inputs = [input1, input2, input3]
        
        // When
        _ = inputs.inputObservables()
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
    }
    
    func test_inputDataContentListener_shouldSucceed() {
        // Setup
        let observer = scheduler.createObserver(Any.self)
        let subject = PublishSubject<String>()
        
        let input1 = InputData.builder()
            .with(input: MockInput.input1)
            .build()
        
        let input2 = InputData.builder()
            .with(input: MockInput.input2)
            .build()
        
        let input3 = InputData.builder()
            .with(input: MockInput.input3)
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
    
    func test_inputValidator_shouldSucceed() {
        // Setup
        let observer = scheduler.createObserver(Any.self)
        
        let input1 = InputData.builder()
            .with(input: MockInput.input1)
            .with(inputValidator: MockInput.input1)
            .build()
        
        let input2 = InputData.builder()
            .with(input: MockInput.input2)
            .with(inputValidator: MockInput.input2)
            .build()
        
        let input3 = InputData.builder()
            .with(input: MockInput.input3)
            .with(inputValidator: MockInput.input3)
            .build()
        
        let inputs = [input1, input2, input3]
        let confirmSubject = PublishSubject<Bool>()
        
        // When
        _ = confirmSubject
            .flatMap({_ in inputs.rxValidate()})
            .logNext({$0.outputs})
            .cast(to: Any.self)
            .subscribe(observer)
        
        for _ in 0..<100 {
            input1.inputContent = "Input1"
            input2.inputContent = "Input2"
            input3.inputContent = "Input3"
            confirmSubject.onNext(true)
        }
        
        // Then
    }
}

enum MockInput {
    case input1
    case input2
    case input3
}

extension MockInput: InputType {
    var identifier: String {
        return String(describing: self)
    }
    
    var isRequired: Bool {
        return Bool.random()
    }
}

extension MockInput: InputValidatorType {
    func validate<S : Sequence>(input: InputDataType, against inputs: S)
        throws where S.Iterator.Element : InputDataType
    {
        if Bool.random() {
            throw Exception(identifier)
        }
    }
}
