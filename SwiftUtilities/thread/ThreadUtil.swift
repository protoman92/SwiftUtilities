//
//  ThreadUtil.swift
//  Heartland Chefs
//
//  Created by Hai Pham on 1/13/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import Foundation

func delay(_ delay: TimeInterval, closure: @escaping () -> Void) {
    let nsec = Double(NSEC_PER_SEC)
    let timeDelay = Double(Int64(delay * nsec)) / nsec
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeDelay,
                                  execute: closure)
}

func mainThread(_ closure: @escaping () -> Void) {
    DispatchQueue.main.async(execute: closure)
}

func background(_ qos: DispatchQoS.QoSClass? = nil,
                closure: @escaping () -> Void) {
    let qos = qos ?? .userInteractive
    DispatchQueue.global(qos: qos).async(execute: closure)
}
