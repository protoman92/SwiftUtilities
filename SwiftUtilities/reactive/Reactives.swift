//
//  Reactives.swift
//  SwiftUtilities
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
    public static func error(_ error: String) -> Observable<E> {
        let exc = Exception(error)
        return Observable.error(exc)
    }
}

public extension Observable {
    
    /// Take a selector that produces a Sequence of some type using the emitted
    /// Element, then apply Observable.from to flatten it.
    ///
    /// - Parameter selector: Selector function closure.
    /// - Returns: An Observable instance.
    public func flatMapSequence<I,S>(_ selector: @escaping (E) throws -> S)
        -> Observable<I> where
        S: Sequence, S.Iterator.Element == I
    {
        return flatMap({Observable<I>.from(try selector($0))})
    }
}

public extension Observable {
    
    /// FlatMap to a Observable which, if nil, is replaced by an empty Observable.
    ///
    /// Beware that using ifEmpty(default:) on a stream filtered by this operator
    /// will not work.
    ///
    /// - Parameter selector: Selector closure function.
    /// - Returns: An Observable instance.
    public func flatMapNonNilOrEmpty<E2>(
        _ selector: @escaping (E) throws -> Observable<E2>?)
        -> Observable<E2>
    {
        return flatMap({try selector($0) ?? .empty()})
    }
    
    /// Map the inner element to an optional second element, and return an
    /// empty Observable if the latter is not present.
    ///
    /// Beware that using ifEmpty(default:) on a stream filtered by this operator
    /// will not work.
    ///
    /// - Parameter selector: Selector closure function.
    /// - Returns: An Observable instance.
    public func mapNonNilOrEmpty<E2>(_ selector: @escaping (E) throws -> E2?)
        -> Observable<E2>
    {
        return flatMap({(e1) throws -> Observable<E2> in
            if let e2 = try selector(e1) {
                return Observable<E2>.just(e2)
            } else {
                return Observable<E2>.empty()
            }
        })
    }
    
    /// Map the inner element to an optional second element, or return a default
    /// value if the latter is nil.
    ///
    /// - Parameters:
    ///   - selector: Selector closure function.
    ///   - defaultValue: E2 instance.
    /// - Returns: An Observable instance.
    public func mapNonNilOrElse<E2>(_ selector: @escaping (E) throws -> E2?,
                                    _ defaultValue: E2) -> Observable<E2> {
        return map({e1 throws -> E2 in
            if let e2 = try selector(e1) {
                return e2
            } else {
                return defaultValue
            }
        })
    }
}

public extension Observable where E: Sequence {
    
    /// If the emitted Element is a Sequence, flatten it.
    ///
    /// - Returns: An Observable instance.
    public func flattenSequence() -> Observable<E.Iterator.Element> {
        return flatMapSequence({$0})
    }
}

public extension Observable {
    
    /// Similar to catchErrorJustReturn, but apply a transformer to the emitted
    /// Error to convert it to Element.
    ///
    /// - Parameter selector: Transformer function closure.
    /// - Returns: An Observable instance.
    public func catchErrorJustReturn(_ selector: @escaping (Error) throws -> E)
        -> Observable<Element>
    {
        return catchError({(error: Error) -> Observable<E> in
            do {
                return Observable.just(try selector(error))
            } catch let e {
                return Observable.error(e)
            }
        })
    }
    
    /// If the Observable is empty, throw an Error.
    ///
    /// - Parameter error: A String value.
    /// - Returns: An Observable instance.
    public func errorIfEmpty(_ error: Error) -> Observable<E> {
        return ifEmpty(switchTo: Observable.error(error))
    }
    
    /// If the Observable is empty, throw an Error.
    ///
    /// - Parameter error: A String value.
    /// - Returns: An Observable instance.
    public func errorIfEmpty(_ error: String) -> Observable<E> {
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
    public func doOnError(_ callback: @escaping (Error) -> Void) -> Observable<E> {
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
    public func doOnCompleted(_ callback: @escaping () -> Void) -> Observable<E> {
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
    public func doOnSubscribe(_ callback: @escaping () -> Void) -> Observable<E> {
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
    public func doOnSubscribed(_ callback: @escaping () -> Void) -> Observable<E> {
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
        let scheduler = ConcurrentDispatchQueueScheduler(qos: qos)
        return subscribeOn(scheduler)
    }
    
    /// Convenient for observeOn with a QoS.
    ///
    /// - Parameter qos: A Quality of Service instance.
    /// - Returns: An Observable instance.
    public func observeOn(qos: DispatchQoS.QoSClass) -> Observable<E> {
        let scheduler = ConcurrentDispatchQueueScheduler(qos: qos)
        return subscribeOn(scheduler)
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

public extension Observable {
    
    /// Delay retry by some time.
    ///
    /// - Parameters:
    ///   - retries: An Int value.
    ///   - delay: A TimeInterval value.
    ///   - scheduler: A SchedulerType instance to schedule the timer.
    ///   - terminateObs: Terminate the retry sequence when this Observable emits
    ///                   an element. This is especially useful when we have
    ///                   an infinite retry count that cannot be disposed of
    ///                   otherwise.
    /// - Returns: An Observable instance.
    public func delayRetry(retries: Int,
                           delay: TimeInterval,
                           scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background),
                           terminateObs: Observable<Void> = Observable<Void>.empty())
        -> Observable<E>
    {
        if delay == 0 {
            return self.retry(retries)
        } else {
            return self.retryWhen({Observable<Int>
                .zip(Observable.range(start: 0, count: retries), $0, resultSelector: {$0.0})
                .delay(delay, scheduler: scheduler)
                .takeUntil(terminateObs)
            })
        }
    }
    
    /// Delay retry by some time interval. This method retries indefinitely.
    ///
    /// - Parameters:
    ///   - delay: A TimeInterval value.
    ///   - scheduler: A SchedulerType instance.
    /// - Returns: An Observable instance.
    public func delayRetry(delay: TimeInterval,
                           scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background))
        -> Observable<E>
    {
        if delay == 0 {
            return self.retry()
        } else {
            return self.retryWhen({$0.delay(delay, scheduler: scheduler)})
        }
    }
}

public extension ConcurrentDispatchQueueScheduler {
    
    /// Get a SchedulerType from a QoS.
    ///
    /// - Parameter qos: A Quality of Service instance.
    /// - Returns: A SchedulerType instance.
    convenience public init(qos: DispatchQoS.QoSClass) {
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
        
        self.init(qos: type)
    }
}
