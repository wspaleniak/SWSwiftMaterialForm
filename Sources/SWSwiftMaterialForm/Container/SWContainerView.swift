//
//  SWContainerView.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 19/07/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import SwiftUI

public struct SWContainerView<T: View>: View {
    
    // MARK: - Properties
    
    @StateObject
    private var viewModel = SWContainerViewModel()
    
    /// The custom container properties.
    @Environment(\.containerStyle)
    private var style
    
    /// The spacing between container fields.
    /// Get dynamic size - in the init method add value with wrapper @ScaledMetric.
    private(set) var spacing: CGFloat
    
    /// Whether there are errors in any field.
    @Binding
    private var errors: Bool
    
    @ViewBuilder
    private var builder: () -> T
    
    // MARK: - Init
    
    public init(
        spacing: CGFloat = 16,
        errors: Binding<Bool> = .constant(false),
        @ViewBuilder builder: @escaping () -> T
    ) {
        self.spacing = spacing
        self._errors = errors
        self.builder = builder
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: spacing) {
            builder()
                .environmentObject(viewModel)
        }
        .background(style.backgroundColor)
        .onPreferenceChange(SWFieldPreferenceKey.self) { newFields in
            newFields.enumerated().forEach { index, fieldData in
                fieldData.id.wrappedValue = index
            }
            viewModel.updateContainerFields(with: newFields)
            errors = viewModel.hasContainerErrors(for: newFields)
        }
        .onChange(of: style.unfocusFields.wrappedValue) { newValue in
            if newValue { viewModel.setFocus(on: nil) }
        }
        .onChange(of: viewModel.focusedFieldID) { newValue in
            if newValue != nil { style.unfocusFields.wrappedValue = false }
        }
        .onTapGesture {
            viewModel.setFocus(on: nil)
        }
        .onAppear {
            viewModel.setContainerStyle(style)
            guard let firstField = viewModel.fields.first,
                  style.startWithFocusedFieldAfter > 0
            else { return }
            Task { @MainActor in
                try await Task.sleep(nanoseconds: UInt64(style.startWithFocusedFieldAfter) * 1_000_000_000)
                if viewModel.focusedFieldID == nil {
                    viewModel.setFocus(on: firstField.id.wrappedValue)
                }
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
