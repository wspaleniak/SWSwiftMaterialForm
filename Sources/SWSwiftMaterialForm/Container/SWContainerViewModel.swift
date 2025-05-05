//
//  SWContainerViewModel.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 19/07/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import SwiftUI

@MainActor
public final class SWContainerViewModel: ObservableObject, Sendable {
    
    // MARK: - Properties
    
    /// The ID of the focused field.
    @Published
    public private(set) var focusedFieldID: Int?
    
    /// Whether the keyboard should be hidden.
    @Published
    public private(set) var hideKeyboard: Bool = false
    
    /// All fields in the container.
    /// But only those who registered in it using .preference(key:value:) modifier.
    /// Key: SWFieldPreferenceKey.self, Value: [SWFieldData].
    private(set) var fields: [SWFieldData] = []
    
    /// The container custom properties available for fields.
    public private(set) var style: SWContainerStyle = SWContainerStyle()
    
    // MARK: - Methods
    
    /// Method allows to set the focus on a selected field.
    public func setFocus(on fieldID: Int?) {
        guard fieldID != focusedFieldID else {
            return
        }
        focusedFieldID = fieldID
    }
    
    /// Method allows to hide keyboard if any field is focused.
    /// Used when user focuse or unfocuse any picker.
    /// Used because pickers have not @FocusState.
    public func hideKeyboard(_ hide: Bool) {
        hideKeyboard = hide
    }
    
    /// Method allows to update the list of fields in the container.
    func updateContainerFields(with fields: [SWFieldData]) {
        self.fields = fields
    }
    
    /// The method allows to set the container custom properties.
    func setContainerStyle(_ style: SWContainerStyle) {
        self.style = style
    }
    
    /// Method allows to check whether any field has an error.
    /// And provides a list of indexes of fields with errors.
    func hasContainerErrors(for fields: [SWFieldData]) -> Bool {
        let erroredFields = fields.compactMap { field in
            switch field.state {
            case .emptyError, .activeError, .filledError: field.id.wrappedValue
            default: nil
            }
        }
        style.erroredFields.wrappedValue = erroredFields
        return !erroredFields.isEmpty
    }
}

// MARK: - Extensions

// TOOLBAR
extension SWContainerViewModel {
    
    /// Available actions on the toolbar.
    public enum ToolbarAction {
        case previousField
        case nextField
        case hideKeyboard
    }
    
    /// Method allows to perform an action by clicking a selected button on the toolbar.
    public func action(_ action: ToolbarAction) {
        switch action {
        case .previousField:
            guard let focusedFieldID, focusedFieldID > 0 else {
                self.focusedFieldID = nil
                return
            }
            var previousField: Int?
            for index in 1...focusedFieldID {
                let previous = fields[focusedFieldID - index]
                if previous.isEnabled {
                    previousField = previous.id.wrappedValue
                    break
                }
                continue
            }
            self.focusedFieldID = previousField
        case .nextField:
            let lastIndex = fields.count - 1
            guard let focusedFieldID, focusedFieldID < lastIndex else {
                self.focusedFieldID = nil
                return
            }
            var nextField: Int?
            for index in 1...lastIndex - focusedFieldID {
                let next = fields[focusedFieldID + index]
                if next.isEnabled {
                    nextField = next.id.wrappedValue
                    break
                }
                continue
            }
            self.focusedFieldID = nextField
        case .hideKeyboard:
            self.focusedFieldID = nil
        }
    }
}
