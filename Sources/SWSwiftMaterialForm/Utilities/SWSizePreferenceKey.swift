//
//  SWSizePreferenceKey.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 22/07/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import SwiftUI

struct SWSizePreferenceKey: PreferenceKey, Sendable {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) { }
}

extension View {
    
    /// The method allows to read the size of the object using a modifier.
    public func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SWSizePreferenceKey.self, value: proxy.size)
            }
        )
        .onPreferenceChange(SWSizePreferenceKey.self, perform: onChange)
    }
}
