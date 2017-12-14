//
//  Reactives.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/28/16.
//  Copyright © 2016 Swiften. All rights reserved.
//

import RxSwift

public extension ObservableConvertibleType {
    
    /// Convenience method to throw an error.
    ///
    /// - Parameter error: A String value.
    /// - Returns: An Observable instance.
    public static func error(_ error: String) -> Observable<E> {
        let exc = Exception(error)
        return Observable.error(exc)
    }
}

public extension ObservableConvertibleType {
    
    /// Take a selector that produces a Sequence of some type using the emitted
    /// Element, then apply Observable.from to flatten it.
    ///
    /// - Parameter selector: Selector function closure.
    /// - Returns: An Observable instance.
    public func flatMapSequence<I,S>(_ selector: @escaping (E) throws -> S)
        -> Observable<I> where
        S: Sequence, S.Iterator.Element == I
    {
        return self.asObservable().flatMap({Observable<I>.from(try selector($0))})
    }
}

public extension ObservableConvertibleType {
    
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
        return self.asObservable().flatMap({try selector($0) ?? .empty()})
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
        return self.asObservable().flatMap({(e1) throws -> Observable<E2> in
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
        return self.asObservable().map({e1 throws -> E2 in
            if let e2 = try selector(e1) {
                return e2
            } else {
                return defaultValue
            }
        })
    }
}

public extension ObservableConvertibleType where E: OptionalType {
    public func mapNonNilOrEmpty() -> Observable<E.Value> {
        return self.mapNonNilOrEmpty({$0.value})
    }
    
    public func mapNonNilOrElse(_ defaultValue: E.Value) -> Observable<E.Value> {
        return self.mapNonNilOrElse({$0.value}, defaultValue)
    }
}

public extension ObservableConvertibleType where E: Sequence {
    
    /// If the emitted Element is a Sequence, flatten it.
    ///
    /// - Returns: An Observable instance.
    public func flattenSequence() -> Observable<E.Iterator.Element> {
        return flatMapSequence({$0})
    }
}

public extension ObservableConvertibleType {
    
    /// Similar to catchErrorJustReturn, but apply a transformer to the emitted
    /// Error to convert it to Element.
    ///
    /// - Parameter selector: Transformer function closure.
    /// - Returns: An Observable instance.
    public func catchErrorJustReturn(_ selector: @escaping (Error) throws -> E)
        -> Observable<E>
    {
        return self.asObservable().catchError({(error: Error) -> Observable<E> in
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
        return self.asObservable().ifEmpty(switchTo: Observable.error(error))
    }
    
    /// If the Observable is empty, throw an Error.
    ///
    /// - Parameter error: A String value.
    /// - Returns: An Observable instance.
    public func errorIfEmpty(_ error: String) -> Observable<E> {
        return self.asObservable().ifEmpty(switchTo: Observable.error(error))
    }
}

public extension ObservableConvertibleType {

    /// Convenience method for do(onNext).
    ///
    /// - Parameter callback: onNext closure.
    /// - Returns: An Observable instance.
    public func doOnNext(_ callback: @escaping (E) -> Void) -> Observable<E> {
        return self.asObservable().`do`(onNext: callback,
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
        return self.asObservable().`do`(onNext: nil,
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
        return self.asObservable().`do`(onNext: nil,
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
        return self.asObservable().`do`(onNext: nil,
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
        return self.asObservable().`do`(onNext: nil,
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
        return self.asObservable().`do`(onNext: nil,
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
    
    /// Check whether the stream is running on main thread or not.
    ///
    /// - Returns: An Observable instance.
    public func logCheckMainThread() -> Observable<E> {
        return logNext({_ in "Currently on main thread: \(Thread.isMainThread)"})
    }
    
    /// Log information regarding the current thread.
    ///
    /// - Returns: An Observable instance.
    public func logCurrentThread() -> Observable<E> {
        return logNext({_ in "Current thread: \(Thread.current)"})
    }
    
    /// Log next with a prefix.
    ///
    /// - Parameters:
    ///   - prefix: A String value.
    ///   - selector: Selector function.
    /// - Returns: An Observable instance.
    public func logNextPrefix(_ prefix: String,
                              _ selector: @escaping (E) -> Any) -> Observable<E> {
        return logNext({"\(prefix)\(selector($0))"})
    }
    
    /// Log next with a prefix.
    ///
    /// - Parameters prefix: A String value.
    /// - Returns: An Observable instance.
    public func logNextPrefix(_ prefix: String) -> Observable<E> {
        return logNextPrefix(prefix, eq)
    }
}

public extension ObservableConvertibleType {
    
    /// Cast the emission to another type, and throw an Error if the cast
    /// fails.
    ///
    /// - Parameter type: The type to be cast to.
    /// - Returns: An Observable instance.
    public func cast<T>(to type: T.Type) -> Observable<T> {
        return self.asObservable().map({(item) -> T in
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
        return self.asObservable().flatMap({(item) -> Observable<T> in
            guard let cast = item as? T else {
                return Observable<T>.empty()
            }
            
            return Observable<T>.just(cast)
        })
    }
}

public extension ObservableConvertibleType {
    
    /// Convenient for subscribeOn with a QoS.
    ///
    /// - Parameter qos: A Quality of Service instance.
    /// - Returns: An Observable instance.
    public func subscribeOnConcurrent(qos: DispatchQoS.QoSClass) -> Observable<E> {
        let scheduler = ConcurrentDispatchQueueScheduler(qos: qos)
        return self.asObservable().subscribeOn(scheduler)
    }
    
    /// Convenient for observeOn with a QoS.
    ///
    /// - Parameter qos: A Quality of Service instance.
    /// - Returns: An Observable instance.
    public func observeOnConcurrent(qos: DispatchQoS.QoSClass) -> Observable<E> {
        let scheduler = ConcurrentDispatchQueueScheduler(qos: qos)
        return self.asObservable().observeOn(scheduler)
    }
    
    /// Convenient for subscribeOn with a QoS.
    ///
    /// - Parameter qos: A Quality of Service instance.
    /// - Returns: An Observable instance.
    public func subscribeOnSerial(qos: DispatchQoS.QoSClass) -> Observable<E> {
        let dQos = DispatchQoS(qosClass: qos, relativePriority: 0)
        let scheduler = SerialDispatchQueueScheduler(qos: dQos)
        return self.asObservable().subscribeOn(scheduler)
    }
    
    /// Convenient for observeOn with a QoS.
    ///
    /// - Parameter qos: A Quality of Service instance.
    /// - Returns: An Observable instance.
    public func observeOnSerial(qos: DispatchQoS.QoSClass) -> Observable<E> {
        let dQos = DispatchQoS(qosClass: qos, relativePriority: 0)
        let scheduler = SerialDispatchQueueScheduler(qos: dQos)
        return self.asObservable().observeOn(scheduler)
    }
    
    /// Subscribe on main thread.
    ///
    /// - Returns: An Observable instance.
    public func subscribeOnMain() -> Observable<E> {
        return self.asObservable().subscribeOn(ConcurrentMainScheduler.instance)
    }
    
    /// Observe on main thread.
    ///
    /// - Returns: An Observable instance.
    public func observeOnMain() -> Observable<E> {
        return self.asObservable().observeOn(MainScheduler.instance)
    }
}

public extension ObservableConvertibleType {
    
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

public extension ObservableConvertibleType {
    
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
            return self.asObservable().retry(retries)
        } else {
            return self.asObservable().retryWhen({
                Observable<Int>
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
            return self.asObservable().retry()
        } else {
            return self.asObservable().retryWhen({$0.delay(delay, scheduler: scheduler)})
        }
    }
}

public extension ObservableConvertibleType {
    
    /// Emit the time at which an element is pushed.
    ///
    /// - Returns: An Observable instance.
    public func timestamp() -> Observable<(element: E, timestamp: TimeInterval)> {
        return self.asObservable().map({($0, Date().timeIntervalSince1970)})
    }
    
    /// Get the time difference between two consecutive elements. The stream
    /// here emits a tuple of index, element and time difference so that the
    /// end user gets access to the max amount of information. For e.g., the
    /// initial time difference may be too small and the user wishes to filter
    /// events based on a threshold time difference. They can then check whether
    /// the index is 0 or the time difference is larger than the threshold.
    ///
    /// - Returns: An Observable instance.
    public func timeDifference() -> Observable<(index: Int, element: E?, difference: TimeInterval)> {
        typealias TimeTuple = (previous: TimeInterval, diff: TimeInterval)
        typealias Emission = (index: Int, element: E?, difference: TimeInterval)
        let initialTuple = TimeTuple(previous: Date().timeIntervalSince1970, diff: 0)
        let initial: (Int, E?, TimeTuple) = (-1, nil, initialTuple)
        
        return timestamp()
            .scan(initial, accumulator: {
                let index = $0.0 + 1
                let element = $1.0
                let current = $1.1
                let diff = current - $0.2.previous
                return (index, element, TimeTuple(current, diff))
            })
            .map({(i, e, t) -> Emission in Emission(i, e, t.diff)})
    }
}

public extension ObservableConvertibleType {
    
    /// Convenience function to zip with another Observable.
    ///
    /// - Parameters:
    ///   - obs: An ObservableConvertibleType instance.
    ///   - selector: Selector function.
    /// - Returns: An Observable instance.
    public func zipWith<O,U>(_ obs: O, _ selector: @escaping (E, O.E) throws -> U)
        -> Observable<U> where
        O: ObservableConvertibleType
    {
        return Observable<U>.zip(self.asObservable(),
                                 obs.asObservable(),
                                 resultSelector: selector)
    }
    
    /// Convenience function to combine latest with another Observable.
    ///
    /// - Parameters:
    ///   - obs: An ObservableConvertibleType instance.
    ///   - selector: Selector function.
    /// - Returns: An Observable instance.
    public func combineLatestWith<O,U>(_ obs: O, _ selector: @escaping (E, O.E) throws -> U)
        -> Observable<U> where
        O: ObservableConvertibleType
    {
        return Observable<U>.combineLatest(self.asObservable(),
                                           obs.asObservable(),
                                           resultSelector: selector)
    }
}

public extension ObservableConvertibleType {
    
    /// Track the initial emission of the current stream. The initial emission
    /// here may not be the very first emission, but the one that is first
    /// emitted when the current stream is subscribed to.
    ///
    /// - Returns: An Observable instance.
    public func trackInitial() -> Observable<(original: E?, current: E?)> {
        return self.asObservable()
            .scan((original: nil, current: nil), accumulator: {
                if let original = $0.0.original {
                    return (original: original, current: $0.1)
                } else {
                    return (original: $0.1, current: $0.1)
                }
            })
    }
    
    /// Only emit the initial emission, i.e. the first emission that appears
    /// after the current stream is subscribed to.
    ///
    /// - Returns: An Observable instance.
    public func initialEmission() -> Observable<E> {
        return trackInitial().mapNonNilOrEmpty({$0.original})
    }
}

public extension ObservableConvertibleType where E: Equatable {
    /// Only emit distinct initial emissions.
    ///
    /// - Returns: An Observable instance.
    public func distinctInitialEmission() -> Observable<E> {
        return initialEmission().distinctUntilChanged()
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
