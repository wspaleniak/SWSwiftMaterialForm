//
//  SWFieldStyleFonts.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 21/07/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import SwiftUI

public struct SWFieldStyleFonts: Sendable {
    
    // MARK: - Properties
    
    /// The font for the label.
    public let label: Font
    
    /// The font for the text and placeholder.
    public let text: Font
    
    /// The font for the error message.
    public let error: Font
    
    // MARK: - Init
    
    public init(
        label: Font = .footnote,
        text: Font = .body,
        error: Font = .footnote
    ) {
        self.label = label
        self.text = text
        self.error = error
    }
}

// MARK: - Extensions

// Predefined styles
extension SWFieldStyleFonts {
    
    /// Predefined standard fonts for the field.
    public static let standard = SWFieldStyleFonts()
}
