//
//  SWFieldStyleColors.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 21/07/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import SwiftUI

public struct SWFieldStyleColors {
    
    // MARK: - Properties
    
    /// The tint color for the field, e.g. the color of the blinking cursor while typing.
    public let tintColor: Color
    
    /// The color of the field text.
    public let textColor: Color
    
    /// The color of the field underline.
    public let underlineColor: Color
    
    // Label colors
    public let labelEmpty: Color
    public let labelEmptyError: Color
    public let labelActive: Color
    public let labelActiveError: Color
    public let labelFilled: Color
    public let labelFilledError: Color
    public let labelDisabled: Color
    
    // Stroke colors
    public let strokeEmpty: Color
    public let strokeEmptyError: Color
    public let strokeActive: Color
    public let strokeActiveError: Color
    public let strokeFilled: Color
    public let strokeFilledError: Color
    public let strokeDisabled: Color
    
    // Background colors
    public let backgroundEmpty: Color
    public let backgroundEmptyError: Color
    public let backgroundActive: Color
    public let backgroundActiveError: Color
    public let backgroundFilled: Color
    public let backgroundFilledError: Color
    public let backgroundDisabled: Color
    
    // MARK: - Init
    
    public init(
        tintColor: Color = .blue,
        textColor: Color = .primary,
        underlineColor: Color = .blue,
        labelEmpty: Color = .gray,
        labelEmptyError: Color = .red,
        labelActive: Color = .blue,
        labelActiveError: Color = .blue,
        labelFilled: Color = .gray,
        labelFilledError: Color = .red,
        labelDisabled: Color = .gray,
        strokeEmpty: Color = .gray,
        strokeEmptyError: Color = .red,
        strokeActive: Color = .blue,
        strokeActiveError: Color = .blue,
        strokeFilled: Color = .gray,
        strokeFilledError: Color = .red,
        strokeDisabled: Color = .gray,
        backgroundEmpty: Color = .gray.opacity(0.2),
        backgroundEmptyError: Color = Color(red: 255/255, green: 204/255, blue: 204/255),
        backgroundActive: Color = Color(red: 204/255, green: 229/255, blue: 255/255),
        backgroundActiveError: Color = Color(red: 204/255, green: 229/255, blue: 255/255),
        backgroundFilled: Color = .gray.opacity(0.2),
        backgroundFilledError: Color = Color(red: 255/255, green: 204/255, blue: 204/255),
        backgroundDisabled: Color = .gray.opacity(0.2)
    ) {
        self.tintColor = tintColor
        self.textColor = textColor
        self.underlineColor = underlineColor
        self.labelEmpty = labelEmpty
        self.labelEmptyError = labelEmptyError
        self.labelActive = labelActive
        self.labelActiveError = labelActiveError
        self.labelFilled = labelFilled
        self.labelFilledError = labelFilledError
        self.labelDisabled = labelDisabled
        self.strokeEmpty = strokeEmpty
        self.strokeEmptyError = strokeEmptyError
        self.strokeActive = strokeActive
        self.strokeActiveError = strokeActiveError
        self.strokeFilled = strokeFilled
        self.strokeFilledError = strokeFilledError
        self.strokeDisabled = strokeDisabled
        self.backgroundEmpty = backgroundEmpty
        self.backgroundEmptyError = backgroundEmptyError
        self.backgroundActive = backgroundActive
        self.backgroundActiveError = backgroundActiveError
        self.backgroundFilled = backgroundFilled
        self.backgroundFilledError = backgroundFilledError
        self.backgroundDisabled = backgroundDisabled
    }
}

// MARK: - Extensions

// Predefined styles
extension SWFieldStyleColors {
    
    /// Predefined standard colors for the field.
    public static let standard = SWFieldStyleColors()
    
    /// Predefined monochromatic colors for the field.
    public static let monochromatic = SWFieldStyleColors(
        tintColor: .primary,
        textColor: .primary,
        underlineColor: .primary,
        labelEmpty: .primary,
        labelEmptyError: .red,
        labelActive: .primary,
        labelActiveError: .primary,
        labelFilled: .primary,
        labelFilledError: .red,
        labelDisabled: .gray,
        strokeEmpty: .primary,
        strokeEmptyError: .red,
        strokeActive: .primary,
        strokeActiveError: .primary,
        strokeFilled: .primary,
        strokeFilledError: .red,
        strokeDisabled: .gray,
        backgroundEmpty: .gray.opacity(0.2),
        backgroundEmptyError: Color(red: 255/255, green: 204/255, blue: 204/255),
        backgroundActive: .gray.opacity(0.2),
        backgroundActiveError: .gray.opacity(0.2),
        backgroundFilled: .gray.opacity(0.2),
        backgroundFilledError: Color(red: 255/255, green: 204/255, blue: 204/255),
        backgroundDisabled: .gray.opacity(0.2)
    )
}
