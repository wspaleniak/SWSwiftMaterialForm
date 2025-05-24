//
//  SWFieldPreferenceKey.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 19/07/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import SwiftUI

public struct SWFieldPreferenceKey: PreferenceKey, Sendable {
    public static var defaultValue: [SWFieldData] = []
    public static func reduce(value: inout [SWFieldData], nextValue: () -> [SWFieldData]) {
        value += nextValue()
    }
}
