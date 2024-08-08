//
//  SWStandardValidator.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 22/07/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import Foundation

public struct SWStandardValidator {
    
    // MARK: - Properties
    
    /// The regular expression of the validator.
    let regex: String
    
    /// The message for the field error label.
    /// When the field state is filledError.
    let message: String
    
    // MARK: - Init
    
    public init(
        regex: String = ".*",
        message: String = "The text entered is incorrect."
    ) {
        self.regex = regex
        self.message = message
    }
}

// MARK: - Extensions

// Predefined validators
extension SWStandardValidator {
    
    /// Predefined validator for the login field.
    public static let login = SWStandardValidator(
        regex: "^[a-zA-Z0-9-]{1,15}$"
    )
    
    /// Predefined validator for the email field.
    public static let email = SWStandardValidator(
        regex: #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
    )
}
