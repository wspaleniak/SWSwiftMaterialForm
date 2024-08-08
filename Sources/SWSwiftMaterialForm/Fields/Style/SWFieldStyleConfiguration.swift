//
//  SWFieldStyleConfiguration.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 20/07/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import SwiftUI

public struct SWFieldStyleConfiguration {
    
    // MARK: - Properties
    
    /// Set of colors for the field.
    public let colors: SWFieldStyleColors
    
    /// Set of fonts for the field.
    public let fonts: SWFieldStyleFonts
    
    /// The shadow of the field.
    public let shadow: SWFieldStyleShadow
    
    /// Whether the field shadow is visible.
    public let shadowVisible: Bool
    
    /// Whether the field background is visible.
    public let backgroundVisible: Bool
    
    /// Whether the field underline is visible.
    public let underlineVisible: Bool
    
    /// The stroke width of the field. If 0.0 it is invisible.
    public let strokeWidth: CGFloat
    
    /// The corner radius of the field.
    public let cornerRadius: CGFloat
    
    // MARK: - Init
    
    public init(
        colors: SWFieldStyleColors,
        fonts: SWFieldStyleFonts,
        shadow: SWFieldStyleShadow,
        shadowVisible: Bool,
        backgroundVisible: Bool,
        underlineVisible: Bool,
        strokeWidth: CGFloat,
        cornerRadius: CGFloat
    ) {
        self.colors = colors
        self.fonts = fonts
        self.shadow = shadow
        self.shadowVisible = shadowVisible
        self.backgroundVisible = backgroundVisible
        self.underlineVisible = underlineVisible
        self.strokeWidth = strokeWidth
        self.cornerRadius = cornerRadius
    }
}

// MARK: - Extensions

// Predefined styles
extension SWFieldStyleConfiguration {
    
    /// Predefined style with stroke and transparent background.
    public static let border = SWFieldStyleConfiguration(
        colors: .standard,
        fonts: .standard,
        shadow: .standard,
        shadowVisible: false,
        backgroundVisible: false,
        underlineVisible: false,
        strokeWidth: 1.0,
        cornerRadius: 8.0
    )
    
    /// Predefined style with visible background and no stroke.
    public static let fill = SWFieldStyleConfiguration(
        colors: .standard,
        fonts: .standard,
        shadow: .standard,
        shadowVisible: false,
        backgroundVisible: true,
        underlineVisible: false,
        strokeWidth: 0.0,
        cornerRadius: 8.0
    )
    
    /// Predefined style with visible background, no stroke and shadow.
    public static let fillShadow = SWFieldStyleConfiguration(
        colors: .standard,
        fonts: .standard,
        shadow: .standard,
        shadowVisible: true,
        backgroundVisible: true,
        underlineVisible: false,
        strokeWidth: 0.0,
        cornerRadius: 8.0
    )
    
    /// Predefined style with visible background and underline when field is focused.
    public static let underline = SWFieldStyleConfiguration(
        colors: .standard,
        fonts: .standard,
        shadow: .standard,
        shadowVisible: false,
        backgroundVisible: true,
        underlineVisible: true,
        strokeWidth: 0.0,
        cornerRadius: 8.0
    )
    
    /// Predefined style with visible background, shadow and underline when field is focused.
    public static let underlineShadow = SWFieldStyleConfiguration(
        colors: .standard,
        fonts: .standard,
        shadow: .standard,
        shadowVisible: true,
        backgroundVisible: true,
        underlineVisible: true,
        strokeWidth: 0.0,
        cornerRadius: 8.0
    )
    
    /// Predefined style with visible background and stroke.
    public static let combo = SWFieldStyleConfiguration(
        colors: .standard,
        fonts: .standard,
        shadow: .standard,
        shadowVisible: false,
        backgroundVisible: true,
        underlineVisible: false,
        strokeWidth: 1.0,
        cornerRadius: 8.0
    )
    
    /// Predefined style with visible background, stroke and shadow.
    public static let comboShadow = SWFieldStyleConfiguration(
        colors: .standard,
        fonts: .standard,
        shadow: .standard,
        shadowVisible: true,
        backgroundVisible: true,
        underlineVisible: false,
        strokeWidth: 1.0,
        cornerRadius: 8.0
    )
}
