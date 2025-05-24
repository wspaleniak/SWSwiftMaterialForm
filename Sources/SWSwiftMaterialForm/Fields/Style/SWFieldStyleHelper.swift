//
//  SWFieldStyleHelper.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 03/08/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import SwiftUI

public enum SWFieldStyleHelper: Sendable {
    
    /// Method allows to get color of the field label based on the current state and style.
    public static func getLabelColor(
        for state: SWFieldState,
        from style: SWFieldStyle
    ) -> Color {
        let colors = style.configuration.colors
        if style.disabled.wrappedValue { return colors.labelDisabled }
        return switch state {
        case .empty: colors.labelEmpty
        case .emptyError(let message): message != nil ? colors.labelEmptyError : colors.labelEmpty
        case .active: colors.labelActive
        case .activeError: colors.labelActiveError
        case .filled: colors.labelFilled
        case .filledError: colors.labelFilledError
        }
    }
    
    /// Method allows to get font of the field label based on the current state and style.
    public static func getLabelFont(
        for state: SWFieldState,
        from style: SWFieldStyle
    ) -> Font {
        switch state {
        case .empty, .emptyError: style.configuration.fonts.text
        default: style.configuration.fonts.label
        }
    }
    
    /// Method allows to get background opacity of the field label based on the current state.
    public static func getLabelBackgroundOpacity(
        for state: SWFieldState
    ) -> CGFloat {
        switch state {
        case .empty, .emptyError: 0.0
        default: 1.0
        }
    }
    
    /// Method allows to get color of the field underline based on the current state and style.
    public static func getUnderlineColor(
        for state: SWFieldState,
        from style: SWFieldStyle
    ) -> Color {
        guard style.configuration.underlineVisible else {
            return .clear
        }
        return switch state {
        case .active, .activeError: style.configuration.colors.underlineColor
        default: .clear
        }
    }
    
    /// Method allows to get color of the field stroke based on the current state and style.
    public static func getStrokeColor(
        for state: SWFieldState,
        from style: SWFieldStyle
    ) -> Color {
        let colors = style.configuration.colors
        if style.disabled.wrappedValue { return colors.strokeDisabled }
        return switch state {
        case .empty: colors.strokeEmpty
        case .emptyError(let message): message != nil ? colors.strokeEmptyError : colors.strokeEmpty
        case .active: colors.strokeActive
        case .activeError: colors.strokeActiveError
        case .filled: colors.strokeFilled
        case .filledError: colors.strokeFilledError
        }
    }
    
    /// Method allows to get color of the field shadow based on the current style.
    public static func getShadowColor(
        from style: SWFieldStyle
    ) -> Color {
        if style.configuration.backgroundVisible && style.configuration.shadowVisible {
            return style.configuration.shadow.color
        } else {
            return .clear
        }
    }
    
    /// Method allows to get color of the field background based on the current state and style.
    public static func getBackgroundColor(
        for state: SWFieldState,
        from style: SWFieldStyle
    ) -> Color {
        let colors = style.configuration.colors
        if style.disabled.wrappedValue { return colors.backgroundDisabled }
        return switch state {
        case .empty: colors.backgroundEmpty
        case .emptyError(let message): message != nil ? colors.backgroundEmptyError : colors.backgroundEmpty
        case .active: colors.backgroundActive
        case .activeError: colors.backgroundActiveError
        case .filled: colors.backgroundFilled
        case .filledError: colors.backgroundFilledError
        }
    }
}
