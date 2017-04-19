//
//  InputData.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/26/16.
//  Copyright © 2016 Swiften. All rights reserved.
//

import RxSwift

/// Implement this protocol to provide input instances. Usually we can use
/// an enum for this purpose.
public protocol InputType {
    
    /// The input's identifier.
    var identifier: String { get }
    
    /// Whether the input is required.
    var isRequired: Bool { get }
}

/// Implement this protocol to provide validation.
public protocol InputValidatorType {
    
    /// Validate an input against a Sequence of inputs. Throw an Error if
    /// validation fails.
    ///
    /// - Parameters:
    ///   - input: The InputData to be validated.
    ///   - inputs: A Sequence of InputData to validate against.
    /// - Throws: An Error if validation fails.
    func validate<S: Sequence>(input: InputDataType, against inputs: S) throws
        where S.Iterator.Element: InputDataType
}

/// Implement this protocol to notify observers of inputs or errors.
public protocol InputNotificationType {
    /// Whether there are input errors.
    var hasErrors: Bool { get }
    
    /// Return either inputs or errors, depending on whether errors are
    /// present.
    var outputs: [String: String] { get }
    
    /// Append an input.
    ///
    /// - Parameters:
    ///   - input: A String value.
    ///   - key: A String value.
    func append(input: String, for key: String)
    
    /// Append an error.
    ///
    /// - Parameters:
    ///   - input: A String value.
    ///   - key: A String value.
    func append(error: String, for key: String)
    
    /// Construct from an Array of InputNotificationComponentType.
    init(from components: [InputNotificationComponentType])
}

/// Implement this protocol to hold notification component for one input.
public protocol InputNotificationComponentType {
    
    /// Whether there is an input error.
    var hasError: Bool { get }
    
    /// The input's identifier.
    var inputKey: String { get }
    
    /// The input value. Depending on whether hasError is true/false, this
    /// can either be an input content or error message.
    var inputValue: String { get }
}

public protocol InputDataType {
    
    /// Create a new InputNotificationType instance.
    ///
    /// - Parameters:
    ///   - components: An Array of InputNotificationComponentType.
    /// - Returns: An InputNotificationType instance.
    static func notification(from components: [InputNotificationComponentType])
        -> InputNotificationType
    
    // This should be a enum string value so that later we can perform input
    // validation easily.
    var inputIdentifier: String { get }
    
    // This is the user' input.
    var inputContent: String { get set }
    
    /// Get a validator instance to validate the input.
    var inputValidator: InputValidatorType? { get }
    
    /// Get an InputDataType Observable.
    var inputDataObservable: Observable<InputDataType> { get }
    
    /// Get an InputDataType Observer.
    var inputDataObserver: AnyObserver<InputDataType> { get }
    
    /// Check whether the input is required.
    var isRequired: Bool { get }
    
    /// Check if input content is empty.
    var isEmpty: Bool { get }
    
    /// Produce a notification component based on existing input.
    ///
    /// - Parameter inputs: A Sequence of InputDataType to validate against.
    /// - Returns: An InputNotificationComponentType instance.
    func notificationComponent<S: Sequence>(validatingAgainst inputs: S)
        -> InputNotificationComponentType
        where S.Iterator.Element: InputDataType
}

/// Use this class to hold input information (such as the input identifier
/// and the current input). Objects of type InputData can be wrapped in a
/// RxSwift Variable to watch for content changes.
public class InputData {
    
    /// Get the input identifier and isRequired flag from this.
    fileprivate var input: InputType?
    
    // This is the user' input.
    fileprivate let content: Variable<String>
    
    /// When the inputContent changes, this listener will call onNext. Lazy
    /// properties that require self needs their types explicitly specified.
    /// Here a BehaviorSubject is used because we want to emit empty input
    /// as well. If we use a PublishSubject, the empty input will be omitted.
    fileprivate lazy var inputSubject: BehaviorSubject<InputDataType> =
        BehaviorSubject<InputDataType>(value: self)
    
    /// Validate inputs when they are confirmed.
    fileprivate var validator: InputValidatorType?
    
    /// This can either be set, or initialized.
    fileprivate var disposeBag: DisposeBag?
    
    fileprivate init() {
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
        
        /// Set the inputData's input.
        ///
        /// - Parameter input: An InputType instance.
        /// - Returns: The current Builder instance.
        public func with(input: InputType) -> Builder {
            inputData.input = input
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
        
        /// Set the inputData's inputValidator.
        ///
        /// - Parameter inputValidator: An InputValidatorType instance.
        /// - Returns: The current Builder instance.
        public func with(inputValidator: InputValidatorType) -> Builder {
            inputData.validator = inputValidator
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
    fileprivate func onInstanceBuilt() {
        // If no DisposeBag is provided, initialize a new one.
        let disposeBag = self.disposeBag ?? DisposeBag()
        self.disposeBag = disposeBag
        
        content.asObservable()
            .doOnNext(contentDidChange)
            .subscribe()
            .addDisposableTo(disposeBag)
    }
    
    /// This method is called when the inputContent changes.
    ///
    /// - Parameter content: A String value.
    fileprivate func contentDidChange(_ content: String) {
        inputDataObserver.onNext(self)
    }
}

public extension InputData {
    
    /// Use this class to aggregate inputs/errors and notify observers.
    public final class Notification {
        
        /// All entered inputs.
        fileprivate var inputs: [String: String]
        
        /// All input errors.
        fileprivate var errors: [String: String]
        
        public required init() {
            inputs = [:]
            errors = [:]
        }
        
        /// Use this class to construct a Notification.
        public final class Component {
            
            /// The input's identifier.
            fileprivate var key = ""
            
            /// The input content.
            fileprivate var value = ""
            
            /// The error message.
            fileprivate var error = ""
        }
    }
}

extension InputData.Notification: InputNotificationType {
    
    /// Detect if there are input errors.
    public var hasErrors: Bool {
        return errors.isNotEmpty
    }
    
    /// Return either inputs or errors, depending on whether errors are
    /// present.
    public var outputs: [String: String] {
        return hasErrors ? errors : inputs
    }
    
    /// Append an input.
    ///
    /// - Parameters:
    ///   - input: A String value.
    ///   - key: A String value. This should be the input identifier.
    public func append(input: String, for key: String) {
        inputs.updateValue(input, forKey: key)
    }
    
    /// Append an error.
    ///
    /// - Parameters:
    ///   - error: A String value.
    ///   - key: A String value. This should be the input identifier.
    public func append(error: String, for key: String) {
        errors.updateValue(error, forKey: key)
    }
    
    public convenience init(from components: [InputNotificationComponentType]) {
        self.init()
        
        for component in components {
            let key = component.inputKey
            let value = component.inputValue
            
            if component.hasError {
                append(error: value, for: key)
            } else {
                append(input: value, for: key)
            }
        }
    }
}

extension InputData.Notification: CustomStringConvertible {
    public var description: String {
        return "hasErrors: \(hasErrors), output: \(outputs)"
    }
}

extension InputData.Notification.Component: InputNotificationComponentType {
    
    /// Detect if there is an input error.
    public var hasError: Bool {
        return error.isNotEmpty
    }
    
    /// The input's identifier.
    public var inputKey: String {
        return key
    }
    
    /// Either the input content, or an error message.
    public var inputValue: String {
        return hasError ? error : value
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
    return lhs.inputIdentifier == rhs.inputIdentifier
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

extension InputData: InputDataType {
    
    /// Return a new Notification.
    ///
    /// - Returns: A Notification instance.
    public static
        func notification(from components: [InputNotificationComponentType])
        -> InputNotificationType
    {
        return Notification(from: components)
    }
    
    /// Return identifier.
    public var inputIdentifier: String {
        guard let input = self.input else {
            debugException()
            return ""
        }
        
        return input.identifier
    }
    
    /// Return isRequired.
    public var isRequired: Bool {
        guard let input = self.input else {
            debugException()
            return false
        }
        
        return input.isRequired
    }
    
    /// Return content.
    public var inputContent: String {
        get { return content.value }
        set { content.value = newValue }
    }
    
    /// Return validator.
    public var inputValidator: InputValidatorType? {
        return validator
    }
    
    /// Return inputSubject as an Observable.
    public var inputDataObservable: Observable<InputDataType> {
        return inputSubject.asObservable()
    }
    
    /// Return inputSubject as an Observer.
    public var inputDataObserver: AnyObserver<InputDataType> {
        return inputSubject.asObserver()
    }
    
    /// Check whether the input is empty.
    public var isEmpty: Bool {
        return inputContent.isEmpty
    }
    
    /// Produce a notification component based on existing input.
    ///
    /// - Parameter inputs: A Sequence of InputDataType to validate against.
    /// - Returns: An InputNotificationComponentType instance.
    public func notificationComponent<S: Sequence>(validatingAgainst inputs: S)
        -> InputNotificationComponentType
        where S.Iterator.Element: InputDataType
    {
        let component = InputData.Notification.Component()
        let value = inputContent
        component.key = inputIdentifier
        component.value = value
        
        if isRequired && value.isEmpty {
            component.error = "input.error.required".localized
        } else if let validator = inputValidator, value.isNotEmpty {
            do {
                try validator.validate(input: self, against: inputs)
            } catch let e {
                component.error = e.localizedDescription
            }
        }
        
        return component
    }
}

public extension Sequence where Iterator.Element: InputDataType {
    
    /// Merge all inputListener into one Observable. We need to use merge
    /// because concat only takes the first element.
    ///
    /// - Returns: An Observable instance.
    public func rxInputObservables() -> Observable<InputDataType> {
        return self.map({$0.inputDataObservable}).mergeAsObservable()
    }
    
    /// Validate reactively and return an InputNotificationType.
    ///
    /// - Returns: An Observable instance.
    public func rxValidate() -> Observable<InputNotificationType> {
        return Observable.from(self)
            .map({$0.notificationComponent(validatingAgainst: self)})
            .toArray()
            .map({Iterator.Element.notification(from: $0)})
    }
    
    /// Check whether all required inputs have been filled.all
    ///
    /// - Returns: An Observable instance.
    public func rxAllRequiredInputFilled() -> Observable<Bool> {
        return Observable.combineLatest(self.map({$0.inputDataObservable}), {
            for input in $0 {
                if input.isRequired && input.isEmpty { return false }
            }
            
            return true
        })
    }
}

public extension Sequence where Iterator.Element == InputData {}
