//
//  RxUtil.swift
//  Heartland Chefs
//
//  Created by Hai Pham on 7/28/16.
//  Copyright © 2016 Swiften. All rights reserved.
//

import RxSwift

public extension Observable {
    
    /// Convenience method to throw an error.
    ///
    /// - Parameter error: A String value.
    /// - Returns: An Observable instance.
    public static func error(_ error: String) -> Observable<Element> {
        let exc = Exception(error)
        return Observable.error(exc)
    }
}

public extension Observable {
    
    /// Apply common schedulers to an Observable stream.
    ///
    /// - Returns: An Observable instance.
    public func applyCommonSchedulers() -> Observable<E> {
        return self
            .subscribeOn(qos: .userInteractive)
            .observeOn(MainScheduler.instance)
    }
    
    /// Switch to an empty Observable if an Error is caught.
    ///
    /// - Returns: An Observable instance.
    public func catchSwitchToEmpty() -> Observable<E> {
        return catchError({_ in Observable.empty()})
    }
    
    /// If the Observable is empty, throw an Error.
    ///
    /// - Parameter error: A String value.
    /// - Returns: An Observable instance.
    public func throwIfEmpty(_ error: Error) -> Observable<E> {
        return ifEmpty(switchTo: Observable.error(error))
    }
    
    /// If the Observable is empty, throw an Error.
    ///
    /// - Parameter error: A String value.
    /// - Returns: An Observable instance.
    public func throwIfEmpty(_ error: String) -> Observable<E> {
        return ifEmpty(switchTo: Observable.error(error))
    }
}

public extension ObservableType {

    /// Convenience method for do(onNext).
    ///
    /// - Parameter callback: onNext closure.
    /// - Returns: An Observable instance.
    public func doOnNext(_ callback: @escaping (E) -> Void) -> Observable<E> {
        return `do`(onNext: callback,
                    onError: nil,
                    onCompleted: nil,
                    onSubscribe: nil,
                    onSubscribed: nil,
                    onDispose: nil)
    }
    
    /// Convenience method for do(onError).
    ///
    /// - Parameter callback: onError closure.
    /// - Returns: An Observable instance.
    public func doOnError(_ callback: @escaping (Error) -> Void)
        -> Observable<E>
    {
        return `do`(onNext: nil,
                    onError: callback,
                    onCompleted: nil,
                    onSubscribe: nil,
                    onSubscribed: nil,
                    onDispose: nil)
    }
    
    /// Convenience method for do(onCompleted).
    ///
    /// - Parameter callback: onCompleted closure.
    /// - Returns: An Observable instance.
    public func doOnCompleted(_ callback: @escaping () -> Void)
        -> Observable<E>
    {
        return `do`(onNext: nil,
                    onError: nil,
                    onCompleted: callback,
                    onSubscribe: nil,
                    onSubscribed: nil,
                    onDispose: nil)
    }
    
    /// Convenience method for do(onSubscribe).
    ///
    /// - Parameter callback: onSubscribe closure.
    /// - Returns: An Observable instance.
    public func doOnSubscribe(_ callback: @escaping () -> Void)
        -> Observable<E>
    {
        return `do`(onNext: nil,
                    onError: nil,
                    onCompleted: nil,
                    onSubscribe: callback,
                    onSubscribed: nil,
                    onDispose: nil)
    }
    
    /// Convenience method for do(onSubscribed).
    ///
    /// - Parameter callback: onSubscribed closure.
    /// - Returns: An Observable instance.
    public func doOnSubscribed(_ callback: @escaping () -> Void)
        -> Observable<E>
    {
        return `do`(onNext: nil,
                    onError: nil,
                    onCompleted: nil,
                    onSubscribe: nil,
                    onSubscribed: callback,
                    onDispose: nil)
    }
    
    /// Convenience method for do(onDispose).
    ///
    /// - Parameter callback: onDispose closure.
    /// - Returns: An Observable instance.
    public func doOnDispose(_ callback: @escaping () -> Void) -> Observable<E> {
        return `do`(onNext: nil,
                    onError: nil,
                    onCompleted: nil,
                    onSubscribe: nil,
                    onSubscribed: nil,
                    onDispose: callback)
    }
    
    /// Print onNext emission.
    ///
    /// - Parameter selector: Closure to convert the item into another object.
    /// - Returns: An Observable instance.
    public func logNext(_ selector: @escaping (E) -> Any) -> Observable<E> {
        return doOnNext({debugPrint(selector($0))})
    }
    
    /// Print onNext emission.
    ///
    /// - Returns: An Observable instance.
    public func logNext() -> Observable<E> {
        return logNext(eq)
    }
    
    /// Print onError emission.
    ///
    /// - Parameter selector: Closure to convert the error into another object.
    /// - Returns: An Observable instance.
    public func logError(_ selector: @escaping (Error) -> Any) -> Observable<E> {
        return doOnError({debugPrint(selector($0))})
    }
    
    /// Print onError emission.
    ///
    /// - Returns: An Observable instance.
    public func logError() -> Observable<E> {
        return logError(eq)
    }
}

public extension Observable {
    
    /// Cast the emission to another type, and throw an Error if the cast
    /// fails.
    ///
    /// - Parameter type: The type to be cast to.
    /// - Returns: An Observable instance.
    public func cast<T>(to type: T.Type) -> Observable<T> {
        return map({(item) -> T in
            guard let cast = item as? T else {
                throw Exception("Failed to cast \(item) to \(type)")
            }
            
            return cast
        })
    }
    
    /// Cast the emission to another type, and switch to an empty Observable
    /// if the cast fails.
    ///
    /// - Parameter type: The type to be cast to.
    /// - Returns: An Observable instance.
    public func ofType<T>(_ type: T.Type) -> Observable<T> {
        return flatMap({(item) -> Observable<T> in
            guard let cast = item as? T else {
                return Observable<T>.empty()
            }
            
            return Observable<T>.just(cast)
        })
    }
}

public extension Observable {
    
    /// Convenient for subscribeOn with a QoS.
    ///
    /// - Parameter qos: A Quality of Service instance.
    /// - Returns: An Observable instance.
    public func subscribeOn(qos: DispatchQoS.QoSClass) -> Observable<E> {
        let type: DispatchQoS
        
        switch qos {
        case .background:
            type = .background
            
        case .default:
            type = .default
            
        case .userInitiated:
            type = .userInitiated
            
        case .utility:
            type = .utility
            
        case .userInteractive:
            fallthrough
            
        default:
            type = .userInteractive
        }
        
        let scheduler = ConcurrentDispatchQueueScheduler(qos: type)
        return subscribeOn(scheduler)
    }
}

public extension Observable {
    
    /// Static if method that accepts a condition selector, and return the
    /// appropriate Observable based on whether the condition is satisfied.
    ///
    /// - Parameters:
    ///   - condition: Conditional closure check.
    ///   - firstSelector: Closure selector.
    ///   - secondSelector: Closure selector.
    /// - Returns: An Observable instance.
    public static func `if`<T>(
        _ condition: () throws -> Bool,
        then firstSelector: () throws -> Observable<T>,
        else secondSelector: (() throws -> Observable<T>)? = nil
    ) -> Observable<T> {
        do {
            if try condition() {
                return try firstSelector()
            } else if let secondSelector = secondSelector {
                return try secondSelector()
            } else {
                return Observable<T>.empty()
            }
        } catch let e {
            return Observable<T>.error(e)
        }
    }
    
    /// flatMap into an Observable if the emitted element passes a condition,
    /// else into another Observable.
    ///
    /// - Parameters:
    ///   - condition: Conditional closure check.
    ///   - firstSelector: Closure selector.
    ///   - secondSelector: Closure selector.
    /// - Returns: An Observable instance.
    public func flatMapIf<T>(
        _ condition: @escaping (E) throws -> Bool,
        then firstSelector: @escaping (E) throws -> Observable<T>,
        else secondSelector: @escaping (E) throws -> Observable<T>
    ) -> Observable<T> {
        return flatMap({(element) -> Observable<T> in
            do {
                if try condition(element) {
                    return try firstSelector(element)
                } else {
                    return try secondSelector(element)
                }
            } catch let e {
                return Observable<T>.error(e)
            }
        })
    }
    
    /// Same as above, but returns an Observable that emits a value of the
    /// same type as that emitted by the source Observable.
    ///
    /// - Parameters:
    ///   - condition: Conditional closure check.
    ///   - firstSelector: Closure selector.
    ///   - secondSelector: Closure selector.
    /// - Returns: An Observable instance.
    public func `if`(
        _ condition: @escaping (E) throws -> Bool,
        then firstSelector: @escaping (E) throws -> Observable<E>,
        else secondSelector: @escaping (E) throws -> Observable<E>
    ) -> Observable<Element> {
        return flatMap({(element) -> Observable<E> in
            do {
                if try condition(element) {
                    return try firstSelector(element)
                } else {
                    return try secondSelector(element)
                }
            } catch let e {
                return Observable.error(e)
            }
        })
    }
    
    /// Same as above, but uses a default secondSelector so that if the
    /// condition fails, return an Observable that emits the value emitted
    /// by the source Observable.
    ///
    /// - Parameters:
    ///   - condition: Conditional closure check.
    ///   - selector: Closure selector.
    /// - Returns: An Observable instance.
    public func `if`(
        _ condition: @escaping (E) throws -> Bool,
        then selector: @escaping (E) throws -> Observable<E>
    ) -> Observable<Element> {
        return `if`(condition, then: selector, else: Observable.just)
    }
}

public extension ObservableType {
    
    /// Static if method that accepts a condition selector, and return the
    /// appropriate value based on whether the condition is satisfied.
    ///
    /// - Parameters:
    ///   - condition: Conditional closure check.
    ///   - firstSelector: Closure selector.
    ///   - secondSelector: Closure selector.
    /// - Returns: An Observable instance.
    public static func `if`<T>(
        _ condition: () throws -> Bool,
        thenReturn firstSelector: () throws -> T,
        elseReturn secondSelector: () throws -> T
    ) -> Observable<T> {
        do {
            let value: T
            
            if try condition() {
                value = try firstSelector()
            } else {
                value = try secondSelector()
            }
            
            return Observable.just(value)
        } catch let e {
            return Observable<T>.error(e)
        }
    }
    
    /// map into a value of a different type if the emitted element passes a
    /// condition.
    ///
    /// - Parameters:
    ///   - condition: Conditional closure check.
    ///   - firstSelector: Closure selector.
    ///   - secondSelector: Closure selector.
    /// - Returns: An Observable instance.
    public func mapIf<T>(
        _ condition: @escaping (E) throws -> Bool,
        thenReturn firstSelector: @escaping (E) throws -> T,
        elseReturn secondSelector: @escaping (E) throws -> T
    ) -> Observable<T> {
        return map({
            do {
                if try condition($0) {
                    return try firstSelector($0)
                } else {
                    return try secondSelector($0)
                }
            } catch let e {
                throw e
            }
        })
    }
    
    /// Same as above, but map into the same type.
    ///
    /// - Parameters:
    ///   - condition: Conditional closure check.
    ///   - firstSelector: Closure selector.
    ///   - secondSelector: Closure selector.
    /// - Returns: An Observable instance.
    public func `if`(
        _ condition: @escaping (E) throws -> Bool,
        thenReturn firstSelector: @escaping (E) throws -> E,
        elseReturn secondSelector: @escaping (E) throws -> E
    ) -> Observable<E> {
        return mapIf(condition,
                     thenReturn: firstSelector,
                     elseReturn: secondSelector)
    }
    
    /// Same as above, but uses a default second selector so that when the
    /// condition fails, the returned Observable emits the same value as that
    /// emitted by the source Observable.
    ///
    /// - Parameters:
    ///   - condition: Conditional closure check.
    ///   - selector: Closure selector.
    /// - Returns: An Observable instance.
    public func `if`(
        _ condition: @escaping (E) throws -> Bool,
        thenReturn selector: @escaping (E) throws -> E
    ) -> Observable<E> {
        return `if`(condition, thenReturn: selector, elseReturn: {$0})
    }
}

public extension ObservableType {
    
    /// Get an Observable that emits incremental Int sequentially.
    ///
    /// - Parameters:
    ///   - start: Inclusive starting Int value.
    ///   - end: Exclusive ending Int value.
    /// - Returns: An Observable instance.
    public static func range(inclusive start: Int,
                             exclusive end: Int) -> Observable<Int> {
        return Observable.from(start..<end)
    }
    
    /// Get an Observable that emits incremental Int sequentially.
    ///
    /// - Parameters:
    ///   - start: Inclusive starting Int value.
    ///   - count: An Int value.
    /// - Returns: An Observable instance.
    public static func range(start: Int, count: Int) -> Observable<Int> {
        return range(inclusive: start, exclusive: start + count)
    }
}
