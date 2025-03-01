//
//  SWTextField.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 19/07/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import SwiftUI

public struct SWTextField: View {
    
    // MARK: - Enums
    
    private enum Constants {
        static let inset: CGFloat = 8.0
        static let labelHorizontalInset: CGFloat = 6.0
        static let labelVerticalInset: CGFloat = 1.0
        static let underlineHeight: CGFloat = 4.0
    }
    
    // MARK: - Properties
    
    /// The view model of the container with all fields.
    @EnvironmentObject
    private var containerViewModel: SWContainerViewModel
    
    /// The custom field properties.
    @Environment(\.fieldStyle)
    private var style
    
    /// The title of the field.
    private(set) var title: String
    
    /// The text entered into the field by the user.
    @Binding
    private(set) var text: String
    
    /// The id of the field.
    /// Assigned in the container view.
    /// Equals to the index of the field in the container.
    /// Used to change the focused field in the container.
    @State
    private(set) var id: Int?
    
    /// The current state of the field.
    @State
    private(set) var state: SWFieldState = .empty
    
    /// Whether the field is focused.
    /// Depends on e.g. the focusedFieldID from the container.
    @FocusState
    private var isFocused: Bool
    
    /// Whether the field has been touched yet.
    @State
    private var wasTouched: Bool = false
    
    /// The error message from the validator.
    /// Depends on the current state.
    @State
    private var errorMessage: String? = nil
    
    /// The width of the extra view.
    @State
    private var extraViewWidth: CGFloat = .zero
    
    /// The height of the text in the field.
    @State
    private var textHeight: CGFloat = .zero
    
    /// The minimum height of the field.
    private var minFieldHeight: CGFloat {
        textHeight + 2 * Constants.inset + style.insets.top + style.insets.bottom
    }
    
    /// The height of the field.
    private var fieldHeight: CGFloat {
        return if let height = style.height {
            height < minFieldHeight ? minFieldHeight : height
        } else {
            minFieldHeight
        }
    }
    
    /// The vertical offset of the field label.
    private var labelVerticalOffset: CGFloat {
        switch state {
        case .empty, .emptyError: .zero
        default: -fieldHeight / 2
        }
    }
    
    /// The color of the field label.
    private var labelColor: Color {
        SWFieldStyleHelper.getLabelColor(
            for: state,
            from: style
        )
    }
    
    /// The font of the field label.
    private var labelFont: Font {
        SWFieldStyleHelper.getLabelFont(
            for: state,
            from: style
        )
    }
    
    /// The opacity of the label background.
    private var labelBackgroundOpacity: CGFloat {
        SWFieldStyleHelper.getLabelBackgroundOpacity(
            for: state
        )
    }
    
    /// The color of the field underline.
    private var underlineColor: Color {
        SWFieldStyleHelper.getUnderlineColor(
            for: state,
            from: style
        )
    }
    
    /// The color of the field stroke.
    private var strokeColor: Color {
        SWFieldStyleHelper.getStrokeColor(
            for: state,
            from: style
        )
    }
    
    /// The color of the field shadow.
    private var shadowColor: Color {
        SWFieldStyleHelper.getShadowColor(
            from: style
        )
    }
    
    /// The color of the field background.
    private var backgroundColor: Color {
        SWFieldStyleHelper.getBackgroundColor(
            for: state,
            from: style
        )
    }
    
    /// The color of the form background.
    private var formBackgroundColor: Color {
        containerViewModel.style.backgroundColor
    }
    
    /// The title of the field label and placeholder.
    private var labelTitle: String {
        switch state {
        case .empty, .emptyError: style.placeholder ?? title
        default: title
        }
    }
    
    // MARK: - Init
    
    public init(
        title: String,
        text: Binding<String>
    ) {
        self.title = title
        self._text = text
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 4) {
            ZStack {
                field
                label
            }
            if errorMessage != nil && errorMessage != "" {
                errorLabel
            }
        }
        .preference(
            key: SWFieldPreferenceKey.self,
            value: [
                SWFieldData(
                    id: $id,
                    state: state,
                    isEnabled: !style.disabled.wrappedValue
                )
            ]
        )
        .onChange(of: text) { newValue in
            limitText(newValue)
            validate(text: newValue)
        }
        .onChange(of: containerViewModel.focusedFieldID) { newValue in
            if newValue == id && !isFocused {
                withAnimation(containerViewModel.style.animation) {
                    isFocused = true
                }
            } else if newValue == nil && isFocused {
                withAnimation(containerViewModel.style.animation) {
                    isFocused = false
                }
            }
        }
        .onChange(of: containerViewModel.hideKeyboard) { newValue in
            if newValue && isFocused { isFocused = false }
        }
        .onChange(of: isFocused) { newValue in
            if !wasTouched && newValue { wasTouched = true }
            validate(isFocused: newValue)
        }
        .onChange(of: state) { newValue in
            withAnimation(containerViewModel.style.animation) {
                if case let .emptyError(message) = state {
                    errorMessage = message
                } else if case let .filledError(message) = state {
                    errorMessage = message
                } else {
                    errorMessage = nil
                }
            }
        }
        .onChange(of: style.customErrorMessage.wrappedValue) { newValue in
            if !newValue.trimmingCharacters(in: .whitespaces).isEmpty, !style.disabled.wrappedValue {
                let isEmpty = text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                if isFocused {
                    state = .activeError
                } else if isEmpty {
                    state = .emptyError(newValue)
                } else {
                    state = .filledError(newValue)
                }
                style.customErrorMessage.wrappedValue = ""
            }
        }
        .onChange(of: style.forceValidation.wrappedValue) { newValue in
            if newValue {
                validate(wasTouched: true)
                style.forceValidation.wrappedValue = false
            }
        }
        .onTapGesture {
            containerViewModel.setFocus(on: id)
        }
        .onSubmit {
            containerViewModel.setFocus(on: nil)
        }
        .onAppear {
            limitText()
            validate()
        }
        .disabled(style.disabled.wrappedValue)
        .animation(containerViewModel.style.animation, value: state)
    }
    
    // MARK: - Subviews
    
    private var field: some View {
        HStack(spacing: .zero) {
            if let extraView = style.extraView {
                extraView
                    .readSize { extraViewWidth = $0.width }
            }
            textField
            style.disabled.wrappedValue ? disabledIcon : nil
        }
        .frame(maxWidth: .infinity)
        .frame(height: fieldHeight)
        .background(
            underline
        )
        .background(
            style.configuration.backgroundVisible ? backgroundColor : formBackgroundColor
        )
        .background(
            transparentReadSizeHelper
        )
        .clipShape(
            RoundedRectangle(cornerRadius: style.configuration.cornerRadius)
        )
        .shadow(
            color: shadowColor,
            radius: style.configuration.shadow.radius,
            x: style.configuration.shadow.x,
            y: style.configuration.shadow.y
        )
        .overlay(
            RoundedRectangle(cornerRadius: style.configuration.cornerRadius)
                .stroke(strokeColor, lineWidth: style.configuration.strokeWidth)
        )
    }
    
    private var label: some View {
        HStack {
            Text(labelTitle)
                .lineLimit(1)
                .padding(.horizontal, Constants.labelHorizontalInset)
                .padding(.vertical, Constants.labelVerticalInset)
                .font(labelFont)
                .foregroundStyle(labelColor)
                .background(formBackgroundColor.opacity(labelBackgroundOpacity))
                .clipShape(Capsule())
                .allowsHitTesting(false)
            Spacer()
        }
        .padding(.horizontal, Constants.inset)
        .padding(.leading, style.insets.leading - Constants.labelHorizontalInset + extraViewWidth)
        .padding(.trailing, style.insets.trailing - Constants.labelHorizontalInset)
        .offset(y: labelVerticalOffset)
    }
    
    @ViewBuilder
    private var textField: some View {
        Group {
            if style.secureText {
                SecureField("", text: $text)
            } else {
                TextField("", text: $text)
            }
        }
        .padding(Constants.inset)
        .padding(style.insets)
        .frame(height: fieldHeight)
        .font(style.configuration.fonts.text)
        .tint(style.configuration.colors.tintColor)
        .foregroundStyle(style.configuration.colors.textColor)
        .focused($isFocused)
        .simultaneousGesture(
            TapGesture()
                .onEnded { containerViewModel.setFocus(on: id) }
        )
    }
    
    private var underline: some View {
        VStack {
            Spacer()
            Rectangle()
                .fill(underlineColor)
                .frame(height: Constants.underlineHeight)
        }
    }
    
    private var disabledIcon: some View {
        (style.disabledIcon ?? Image(systemName: "lock.fill"))
            .font(style.configuration.fonts.text)
            .foregroundStyle(style.configuration.colors.labelDisabled)
            .padding(.trailing, Constants.inset + style.insets.trailing)
    }
    
    private var errorLabel: some View {
        Text(errorMessage ?? "")
            .lineLimit(2)
            .font(style.configuration.fonts.error)
            .foregroundStyle(style.configuration.colors.labelFilledError)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var transparentReadSizeHelper: some View {
        Text("READ SIZE TEXT")
            .lineLimit(1)
            .font(style.configuration.fonts.text)
            .foregroundStyle(.clear)
            .readSize { textHeight = $0.height }
    }
    
    // MARK: - Private methods
    
    /// Method allows to limit the length of text entered in the field.
    private func limitText(_ newText: String? = nil) {
        let text = newText ?? self.text
        guard let limit = style.limitText else {
            return
        }
        if text.count > limit {
            let startIndex = text.startIndex
            let endIndex = text.index(text.startIndex, offsetBy: limit)
            self.text = String(text[startIndex..<endIndex])
        } else {
            self.text = text
        }
    }
    
    /// Method allows to validate the text entered in the field.
    private func validate(text: String? = nil, isFocused: Bool? = nil, wasTouched: Bool? = nil) {
        SWValidationHelper.validateFieldText(
            text: text ?? self.text,
            state: &state,
            standardValidator: style.standardValidator,
            customValidator: style.customValidator,
            isRequired: style.required,
            isFocused: isFocused ?? self.isFocused,
            isDisabled: style.disabled.wrappedValue,
            wasTouched: wasTouched ?? self.wasTouched
        )
    }
}
