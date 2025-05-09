//
//  SWContainer.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 19/07/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import SwiftUI

public struct SWContainer<T: View>: View {
    
    // MARK: - Properties
    
    /// The custom container properties.
    @Environment(\.containerStyle)
    private var style
    
    @StateObject
    private var viewModel = SWContainerViewModel()
    
    /// Whether there are errors in any field.
    @Binding
    private var errors: Bool
    
    /// The spacing between container fields.
    /// Get dynamic size - in the init method add value with wrapper @ScaledMetric.
    private let spacing: CGFloat
    
    private let builder: T
    
    // MARK: - Init
    
    public init(
        spacing: CGFloat = 16,
        errors: Binding<Bool> = .constant(false),
        @ViewBuilder builder: @escaping () -> T
    ) {
        self.spacing = spacing
        self._errors = errors
        self.builder = builder()
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: spacing) {
            builder
                .environmentObject(viewModel)
        }
        .onPreferenceChange(SWFieldPreferenceKey.self) { newFields in
            newFields.enumerated().forEach { index, fieldData in
                fieldData.id.wrappedValue = index
            }
            viewModel.updateContainerFields(with: newFields)
            errors = viewModel.hasContainerErrors(for: newFields)
        }
        .onChange(of: viewModel.focusedFieldID) { newValue in
            if newValue != nil { style.unfocusFields.wrappedValue = false }
            style.focusedFieldID.wrappedValue = newValue
        }
        .onChange(of: style.focusedFieldID.wrappedValue) { newValue in
            guard newValue != viewModel.focusedFieldID else {
                return
            }
            viewModel.setFocus(on: newValue)
        }
        .onChange(of: style.unfocusFields.wrappedValue) { newValue in
            if newValue { viewModel.setFocus(on: nil) }
        }
        .onTapGesture {
            viewModel.setFocus(on: nil)
        }
        .task {
            viewModel.setContainerStyle(style)
            guard let firstField = viewModel.fields.first,
                  style.startWithFocusedFieldAfter > 0
            else { return }
            try? await Task.sleep(
                nanoseconds: UInt64(style.startWithFocusedFieldAfter) * 1_000_000_000
            )
            if viewModel.focusedFieldID == nil {
                viewModel.setFocus(on: firstField.id.wrappedValue)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                if style.toolbarVisible && viewModel.focusedFieldID != nil {
                    HStack(spacing: 12) {
                        if viewModel.fields.count > 1 {
                            previousButton
                            nextButton
                        }
                        Spacer()
                        hideKeyboardButton
                    }
                    .tint(style.toolbarTintColor)
                    .font(style.toolbarFont)
                    .padding(.leading, 8)
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var previousButton: some View {
        Button {
            viewModel.action(.previousField)
        } label: {
            Image(systemName: "chevron.left")
        }
    }
    
    private var nextButton: some View {
        Button {
            viewModel.action(.nextField)
        } label: {
            Image(systemName: "chevron.right")
        }
    }
    
    private var hideKeyboardButton: some View {
        Button {
            viewModel.action(.hideKeyboard)
        } label: {
            Text(style.toolbarButtonTitle)
        }
    }
}
