//
//  SWFieldData.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 19/07/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import SwiftUI

public struct SWFieldData: Equatable, Sendable {
    
    // MARK: - Properties
    
    /// The ID of the field.
    var id: Binding<Int?>
    
    /// The state of the field.
    var state: SWFieldState
    
    /// Whether the field is enabled.
    var isEnabled: Bool
    
    // MARK: - Init
    
    public init(
        id: Binding<Int?>,
        state: SWFieldState,
        isEnabled: Bool
    ) {
        self.id = id
        self.state = state
        self.isEnabled = isEnabled
    }
    
    // MARK: - Methods
    
    public static func == (lhs: SWFieldData, rhs: SWFieldData) -> Bool {
        lhs.id.wrappedValue == rhs.id.wrappedValue &&
        lhs.state == rhs.state &&
        lhs.isEnabled == rhs.isEnabled
    }
}
