//
//  SWValidationResult.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 20/07/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import Foundation

public enum SWValidationResult {
    /// Result of correct validation.
    case ok
    /// Result of incorrect validation with error message.
    /// The error message is required but it can be empty string.
    case error(message: String)
}
