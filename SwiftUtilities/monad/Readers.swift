//
//  Readers.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 7/8/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import Foundation
import RxSwift

public typealias RxReader<L,R> = Reader<L,Observable<R>>
