//
//  InputData.swift
//  Heartland Chefs
//
//  Created by Hai Pham on 7/26/16.
//  Copyright © 2016 Swiften. All rights reserved.
//

import RxSwift

/// Use this class to hold input information (such as the input identifier
/// and the current input). Objects of type InputData can be wrapped in a
/// RxSwift Variable to watch for content changes.
public struct InputData {
    // This should be a enum string value so that later we can perform input
    // validation easily.
    fileprivate var identifier: String
    
    // This should be a human-readable description that explains what the input
    // is for. It shall be used for error messages.
    fileprivate var header: String
    
    // This is the user' input.
    fileprivate var content: Variable<String>
    
    // Whether the input is required. This is used to check for blank input
    // fields that must be filled.
    fileprivate var isRequired: Bool
    
    /// When the inputContent changes, this listener will call onNext.
    fileprivate let inputListener: PublishSubject<InputData>
    
    fileprivate var disposeBag: DisposeBag?
    
    fileprivate init() {
        identifier = ""
        header = ""
        isRequired = true
        inputListener = PublishSubject<InputData>()
        content = Variable("")
    }
}

public extension InputData {
    
    /// Return a Builder instance.
    ///
    /// - Returns: A Builder instance.
    public static func builder() -> Builder {
        return Builder()
    }
    
    /// Buider class for InputData.
    public final class Builder {
        fileprivate var inputData: InputData
        
        fileprivate init() {
            inputData = InputData()
        }
        
        /// Set the inputData's identifier.
        ///
        /// - Parameter identifier: A String value.
        /// - Returns: The current Builder instance.
        public func with(identifier: String) -> Builder {
            inputData.identifier = identifier
            return self
        }
        
        /// Set the inputData's header.
        ///
        /// - Parameter header: A String value.
        /// - Returns: The current Builder instance.
        public func with(header: String) -> Builder {
            inputData.header = header
            return self
        }
        
        /// Set the inputData's disposeBag.
        ///
        /// - Parameter disposeBag: A DisposeBag instance.
        /// - Returns: The current Builder instance.
        public func with(disposeBag: DisposeBag) -> Builder {
            inputData.disposeBag = disposeBag
            return self
        }
        
        /// Set the inputData's isRequired flag.
        ///
        /// - Parameter required: A Bool value.
        /// - Returns: The current Builder instance.
        public func isRequired(_ required: Bool) -> Builder {
            inputData.isRequired = required
            return self
        }
        
        /// Return inputData.
        ///
        /// - Returns: An InputData instance.
        public func build() -> InputData {
            inputData.onInstanceBuilt()
            return inputData
        }
    }
}

fileprivate extension InputData {
    
    /// This method is called when Builder.build() is called.
    fileprivate mutating func onInstanceBuilt() {
        // If no DisposeBag is provided, initialize a new one.
        if disposeBag == nil {
            disposeBag = DisposeBag()
        }
        
        guard let disposeBag = self.disposeBag else {
            return
        }
        
        content.asObservable()
            .doOnNext(contentDidChange)
            .subscribe()
            .addDisposableTo(disposeBag)
    }
    
    /// This method is called when the inputContent changes.
    ///
    /// - Parameter content: A String value.
    fileprivate func contentDidChange(_ content: String) {
        inputListener.onNext(self)
    }
}

public extension InputData {
    
    /// Return identifier.
    public var inputIdentifier: String {
        return identifier
    }
    
    /// Return header.
    public var inputHeader: String {
        return header
    }
    
    /// Return isRequired.
    public var isInputRequired: Bool {
        return isRequired
    }
    
    /// Return content.
    public var inputContent: String {
        get { return content.value }
        set { content.value = newValue }
    }
    
    /// Return inputListener.
    public var inputDataListener: AnyObserver<InputData> {
        return inputListener.asObserver()
    }
    
    /// Check whether the input is empty.
    public var isEmpty: Bool {
        return inputContent.isEmpty
    }
}

extension InputData: CustomStringConvertible {
    public var description: String {
        return "Content: \(inputContent), Required: \(isRequired)"
    }
}

extension InputData: CustomComparisonProtocol {
    public func equals(object: InputData?) -> Bool {
        if let object = object {
            return object == self
        }
        
        return false
    }
}

public func ==(lhs: InputData, rhs: InputData) -> Bool {
    return lhs.identifier == rhs.identifier && lhs.header == lhs.header
}

public protocol InputDataType {
    // This should be a enum string value so that later we can perform input
    // validation easily.
    var inputIdentifier: String { get }
    
    // This should be a human-readable description that explains what the input
    // is for. It shall be used for error messages.
    var inputHeader: String { get }
    
    // This is the user' input.
    var inputContent: String { get set }
}

extension InputData: ObservableConvertibleType {
    public typealias E = String
    
    /// Return an Observable that emits changes to this InputData.
    ///
    /// - Returns: An Observable instance.
    public func asObservable() -> Observable<String> {
        return content.asObservable()
    }
}

extension InputData: ObserverType {
    public func on(_ event: Event<String>) {
        switch event {
        case .next(let element):
            content.value = element
            
        case .error(let error):
            content.value = error.localizedDescription
            
        default:
            break
        }
    }
}

extension InputData: InputDataType {}

public extension Sequence where Iterator.Element: InputDataType {
    
    /// Get all inputs from the current Sequence of InputDataType.
    ///
    /// - Returns: A Dictionary instance.
    public func allInputs() -> [String: String] {
        var inputs: [String: String] = [:]
        
        self.forEach({
            inputs.updateValue($0.inputContent, forKey: $0.inputIdentifier)
        })
        
        return inputs
    }
}

public extension Sequence where Iterator.Element == InputData {
    
    /// Merge all inputListener into one Observable. We need to use merge 
    /// because concat only takes the first element.
    ///
    /// - Returns: An Observable instance.
    public func inputListeners() -> Observable<Iterator.Element> {
        return self.map({$0.inputListener}).mergeAsObservable()
    }
}
