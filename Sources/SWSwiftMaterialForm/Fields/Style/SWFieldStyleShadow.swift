//
//  SWFieldStyleShadow.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 24/07/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import SwiftUI

public struct SWFieldStyleShadow: Sendable {
    
    // MARK: - Properties
    
    /// The color of the shadow.
    public let color: Color
    
    /// The radius of the shadow.
    public let radius: CGFloat
    
    /// The horizontal shift of the field shadow.
    public let x: CGFloat
    
    /// The vertical shift of the field shadow.
    public let y: CGFloat
    
    // MARK: - Init
    
    public init(
        color: Color = .primary.opacity(0.15),
        radius: CGFloat = 4.0,
        x: CGFloat = 0.0,
        y: CGFloat = 4.0
    ) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}

// MARK: - Extensions

// Predefined shadows
extension SWFieldStyleShadow {
    
    /// Predefined standard shadow for the field.
    public static let standard = SWFieldStyleShadow()
}
