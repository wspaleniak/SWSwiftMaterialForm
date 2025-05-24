//
//  SWValidationHelper.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 22/07/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import Foundation

public enum SWValidationHelper: Sendable {
    
    /// Only for fields with the text entered by the user.
    public static func validateFieldText(
        text: String,
        state: inout SWFieldState,
        standardValidator: SWStandardValidator?,
        customValidator: SWCustomValidator?,
        isRequired: SWValidationRequired,
        isFocused: Bool,
        isDisabled: Bool,
        wasTouched: Bool
    ) {
        let isEmpty = text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        guard !isDisabled else {
            state = isEmpty ? .empty : .filled
            return
        }
        let requiredResult = requiredValidation(
            isEmpty: isEmpty,
            isRequired: isRequired
        )
        switch requiredResult {
        case .ok:
            validateText(
                text: text,
                state: &state,
                standardValidator: standardValidator,
                customValidator: customValidator,
                isFocused: isFocused,
                wasTouched: wasTouched
            )
        case .error(let message):
            setRequiredInvalidState(
                state: &state,
                message: message,
                isFocused: isFocused,
                wasTouched: wasTouched
            )
        }
    }
    
    /// Only for picker fields.
    public static func validateFieldPicker(
        selection: Any?,
        state: inout SWFieldState,
        isRequired: SWValidationRequired,
        isFocused: Bool,
        isDisabled: Bool,
        wasTouched: Bool
    ) {
        let isEmpty = selection == nil
        guard !isDisabled else {
            state = isEmpty ? .empty : .filled
            return
        }
        let requiredResult = requiredValidation(
            isEmpty: isEmpty,
            isRequired: isRequired
        )
        switch requiredResult {
        case .ok:
            setValidState(
                state: &state,
                isEmpty: isEmpty,
                isFocused: isFocused
            )
        case .error(let message):
            setRequiredInvalidState(
                state: &state,
                message: message,
                isFocused: isFocused,
                wasTouched: wasTouched
            )
        }
    }
    
    // MARK: - Private methods
    
    /// Method allows to validate the text entered in the field.
    private static func validateText(
        text: String,
        state: inout SWFieldState,
        standardValidator: SWStandardValidator?,
        customValidator: SWCustomValidator?,
        isFocused: Bool,
        wasTouched: Bool
    ) {
        let isEmpty = text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let validationResult: SWValidationResult = if let customValidator {
            customValidator(text)
        } else if let standardValidator {
            standardValidation(text, with: standardValidator)
        } else {
            .ok
        }
        switch validationResult {
        case .ok:
            setValidState(
                state: &state,
                isEmpty: isEmpty,
                isFocused: isFocused
            )
        case .error(let message):
            setInvalidState(
                state: &state,
                message: message,
                isEmpty: isEmpty,
                isFocused: isFocused,
                wasTouched: wasTouched
            )
        }
    }
    
    /// Method allows to validate the text using the built-in validator.
    private static func standardValidation(
        _ text: String,
        with validator: SWStandardValidator
    ) -> SWValidationResult {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .ok
        }
        let range = NSRange(location: 0, length: text.utf16.count)
        let regex = try? NSRegularExpression(pattern: validator.regex)
        let result = regex?.firstMatch(in: text, range: range) != nil
        return result ? .ok : .error(message: validator.message)
    }
    
    /// Method allows to validate the field using the required validator.
    private static func requiredValidation(
        isEmpty: Bool,
        isRequired: SWValidationRequired
    ) -> SWValidationResult {
        switch isRequired {
        case .notRequired:
            return .ok
        case .required(let message):
            return isEmpty ? .error(message: message) : .ok
        }
    }
    
    /// Method allows to set a new state when validation was successful.
    private static func setValidState(
        state: inout SWFieldState,
        isEmpty: Bool,
        isFocused: Bool
    ) {
        if isEmpty {
            state = isFocused ? .active : .empty
        } else {
            state = isFocused ? .active : .filled
        }
    }
    
    /// Method allows to set a new state when validation was not successful.
    private static func setInvalidState(
        state: inout SWFieldState,
        message: String,
        isEmpty: Bool,
        isFocused: Bool,
        wasTouched: Bool
    ) {
        guard wasTouched else {
            state = isEmpty ? .emptyError(nil) : .filledError(message)
            return
        }
        if isEmpty {
            state = isFocused ? .activeError : .emptyError(message)
        } else {
            state = isFocused ? .activeError : .filledError(message)
        }
    }
    
    /// Method allows to set a new state when required validation was not successful.
    private static func setRequiredInvalidState(
        state: inout SWFieldState,
        message: String,
        isFocused: Bool,
        wasTouched: Bool
    ) {
        if wasTouched {
            state = isFocused ? .activeError : .emptyError(message)
        } else {
            state = .emptyError(nil)
        }
    }
}

// MARK: - Custom validator

/// The type of the custom validator.
public typealias SWCustomValidator = (String) -> SWValidationResult
