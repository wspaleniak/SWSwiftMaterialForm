//
//  SWExtensions.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 26/07/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import SwiftUI

extension View {
    
    /// Method allows to remove the white background from the text editor.
    func textEditorTransparentScrolling() -> some View {
        if #available(iOS 16.0, *) {
            return scrollContentBackground(.hidden)
        } else {
            return onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
        }
    }
}
