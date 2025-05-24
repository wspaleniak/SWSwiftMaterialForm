//
//  SWFieldState.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 19/07/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import Foundation

public enum SWFieldState: Equatable, Sendable {
    /// When the field is unfocused and the text is empty.
    case empty
    /// When the field is unfocused and the text is empty but the field is required.
    case emptyError(String?)
    /// When the field is focused.
    case active
    /// When the field is focused but the text has an error.
    case activeError
    /// When the field is unfocused and the text is not empty.
    case filled
    /// When the field is unfocused and the text is not empty but has an error.
    case filledError(String?)
}
