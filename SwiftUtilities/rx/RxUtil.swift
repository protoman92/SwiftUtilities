//
//  RxUtil.swift
//  Heartland Chefs
//
//  Created by Hai Pham on 7/28/16.
//  Copyright © 2016 Swiften. All rights reserved.
//

import RxSwift

public extension Observable {
    
    /// Apply common schedulers to an Observable stream.
    ///
    /// - Returns: An Observable instance.
    public func applyCommonSchedulers() -> Observable<E> {
        return self
            .subscribeOn(qos: .userInteractive)
            .observeOn(MainScheduler.instance)
    }
    
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
    
    public func subscribe<O>(_ o: O, tag: OperationProtocol?) -> Disposable
        where O: LifecycleObserver, O.E == Element {
        return subscribe(
            onNext: {
                if o.canObserve(tag) {
                    o.onNext($0, tag: tag)
                }
            },
            onError: {
                if o.canObserve(tag) {
                    o.onError($0, tag: tag)
                }
            },
            onCompleted: {
                if o.canObserve(tag) {
                    o.onCompleted(tag)
                }
            },
            onDisposed: {
                if o.canObserve(tag) {
                    o.onDisposed(tag)
                }
            })
    }
}

/// Class instances that make use of rx may implement this protocol to avoid
/// Observable emission, i.e. when a ViewController is not present on screen
/// and we want to stop fetching data.
public protocol LifecycleObserver {
    associatedtype E
    
    func canObserve(_ tag: OperationProtocol?) -> Bool
    
    func onCompleted(_ tag: OperationProtocol?)
    
    func onError(_ error: Error, tag: OperationProtocol?)
    
    func onNext(_ element: E, tag: OperationProtocol?)
    
    func onDisposed(_ tag: OperationProtocol?)
}
