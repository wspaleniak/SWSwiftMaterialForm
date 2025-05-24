//
//  SWValidationRequired.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 28/07/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import Foundation

public enum SWValidationRequired: Sendable {
    /// Whether the field is not required.
    case notRequired
    /// Whether the field is required.
    /// The error message is required but it can be empty string.
    case required(message: String = "The field is required.")
}
