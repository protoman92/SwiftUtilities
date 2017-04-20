//
//  InputType.swift
//  SwiftUtilities
//
//  Created by Hai Pham on 4/20/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// Implement this protocol to provide input instances. Usually we can use
/// an enum for this purpose. Each instance shall provide the necessary
/// information for an input.
public protocol InputDetailType {
    
    /// The input's identifier.
    var identifier: String { get }
    
    /// Whether the input is required.
    var isRequired: Bool { get }
    
    /// The InputType associated with this instance.
    var inputType: InputType { get }
}

/// Implement this protocol to provide information to populate input views.
public protocol InputType {}

/// Implement this protocol to provide implementation details for text inputs.
public protocol TextInputType: InputType {
    
    /// The UIKeyboardType to use with soft input.
    var keyboardType: UIKeyboardType? { get }
    
    /// Whether the input should be secured e.g. password inputs.
    var isSecureInput: Bool { get }
}
