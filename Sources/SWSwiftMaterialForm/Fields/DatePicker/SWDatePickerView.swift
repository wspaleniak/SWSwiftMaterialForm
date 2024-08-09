//
//  SWDatePickerView.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 27/07/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import SwiftUI

public struct SWDatePickerView: View {
    
    // MARK: - Enums
    
    private enum Constants {
        static let inset: CGFloat = 8.0
        static let labelHorizontalInset: CGFloat = 6.0
        static let labelVerticalInset: CGFloat = 1.0
        static let toolbarVerticalInset: CGFloat = 12.0
        static let toolbarHorizontalInset: CGFloat = 24.0
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
    /// Displayed as a placeholder and label.
    private(set) var title: String
    
    /// The type of the picker with the format as string.
    private(set) var type: SWDatePickerType
    
    /// The selected formatted date from the picker.
    @Binding
    private(set) var selection: String?
    
    /// The id of the field.
    /// Assigned in the container view.
    /// Equals to the index of the field in the container.
    /// Used to change the focused field in the container.
    @State
    private(set) var id: Int?
    
    /// The current state of the field.
    @State
    private(set) var state: SWFieldState = .empty
    
    /// The selected raw date from the picker.
    @State
    private var selectedDate: Date = .now
    
    /// Whether the field is focused.
    /// Depends on e.g. the focusedFieldID from the container.
    @State
    private var isFocused: Bool = false
    
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
    
    /// The width of the field.
    /// Used for set the maximum width of the picker.
    @State
    private var fieldWidth: CGFloat = .zero
    
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
    
    /// The text value of the selected date or hour from the picker.
    private var text: String {
        switch state {
        case .empty, .emptyError: ""
        default: if let selection { selection } else { dateToString(selectedDate) }
        }
    }
    
    /// The date picker components available for the selected type.
    private var components: DatePickerComponents {
        switch type {
        case .date: [.date]
        case .hour: [.hourAndMinute]
        case .dateAndHour: [.date, .hourAndMinute]
        }
    }
    
    /// The date formatter for the selected date.
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = switch type {
        case .date(let format): format
        case .hour(let format): format
        case .dateAndHour(let format): format
        }
        return formatter
    }
    
    // MARK: - Init
    
    public init(
        title: String,
        type: SWDatePickerType,
        selection: Binding<String?>
    ) {
        self.title = title
        self.type = type
        self._selection = selection
    }
    
    // MARK: -  Body
    
    public var body: some View {
        VStack(spacing: 4) {
            field
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
        .onChange(of: selection) { newValue in
            guard let newValue else {
                validate(selection: newValue)
                return
            }
            guard let newDate = stringToDate(newValue) else {
                self.selection = nil
                return
            }
            guard newDate != selectedDate else {
                return
            }
            selectedDate = newDate
            validate(selection: newValue)
        }
        .onChange(of: selectedDate) { newValue in
            guard dateToString(newValue) != selection else {
                return
            }
            selection = dateToString(newValue)
        }
        .onChange(of: containerViewModel.focusedFieldID) { newValue in
            if newValue == id && !isFocused {
                withAnimation(containerViewModel.style.animation) {
                    isFocused = true
                }
            } else if newValue != id && isFocused {
                withAnimation(containerViewModel.style.animation) {
                    isFocused = false
                }
            }
        }
        .onChange(of: isFocused) { newValue in
            if !wasTouched && newValue {
                selection = dateToString(selectedDate)
                wasTouched = true
            }
            validate(isFocused: newValue)
            containerViewModel.hideKeyboard(newValue)
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
        .onTapGesture {
            containerViewModel.setFocus(on: id)
        }
        .onAppear {
            guard let selection else {
                validate()
                return
            }
            guard let newDate = stringToDate(selection) else {
                self.selection = nil
                return
            }
            selectedDate = newDate
            validate()
        }
        .disabled(style.disabled.wrappedValue)
        .animation(containerViewModel.style.animation, value: state)
    }
    
    // MARK: - Subviews
    
    private var field: some View {
        VStack(spacing: .zero) {
            textField
            if isFocused {
                Divider()
                picker
            }
            if isFocused && containerViewModel.style.toolbarVisible {
                Divider()
                toolbar
            }
        }
        .frame(maxWidth: .infinity)
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
        .overlay {
            label
        }
        .readSize { fieldWidth = $0.width }
    }
    
    private var label: some View {
        VStack(spacing: .zero) {
            ZStack {
                HStack {
                    Text(title)
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
            .frame(maxWidth: .infinity)
            .frame(height: fieldHeight)
            
            Spacer(minLength: .zero)
        }
    }
    
    private var textField: some View {
        HStack(spacing: .zero) {
            if let extraView = style.extraView {
                extraView
                    .readSize { extraViewWidth = $0.width }
            }
            Text(text)
                .lineLimit(1)
                .padding(Constants.inset)
                .padding(style.insets)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(style.configuration.fonts.text)
                .foregroundStyle(style.configuration.colors.textColor)
            
            if style.disabled.wrappedValue {
                disabledIcon
            } else {
                chevronIcon
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: fieldHeight)
    }
    
    private var picker: some View {
        DatePicker(
            "",
            selection: $selectedDate,
            displayedComponents: components
        )
        .frame(maxWidth: fieldWidth)
        .datePickerStyle(.wheel)
    }
    
    private var toolbar: some View {
        HStack(spacing: .zero) {
            if containerViewModel.fields.count > 1 {
                HStack(spacing: Constants.toolbarHorizontalInset) {
                    Button {
                        containerViewModel.action(.previousField)
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    Button {
                        containerViewModel.action(.nextField)
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                }
            }
            Spacer(minLength: .zero)
            Button {
                containerViewModel.action(.hideKeyboard)
            } label: {
                Text(containerViewModel.style.toolbarButtonTitle)
            }
        }
        .tint(containerViewModel.style.toolbarTintColor)
        .font(containerViewModel.style.toolbarFont)
        .padding(.leading, Constants.inset + style.insets.leading)
        .padding(.trailing, Constants.inset + style.insets.trailing)
        .padding(.top, Constants.toolbarVerticalInset)
        .padding(.bottom, Constants.toolbarVerticalInset + (style.configuration.underlineVisible ? Constants.underlineHeight : .zero))
    }
    
    private var underline: some View {
        VStack {
            Spacer()
            Rectangle()
                .fill(underlineColor)
                .frame(height: Constants.underlineHeight)
        }
    }
    
    private var chevronIcon: some View {
        Image(systemName: "chevron.down")
            .rotationEffect(.degrees(isFocused ? 180 : 0))
            .font(style.configuration.fonts.text)
            .foregroundStyle(labelColor)
            .padding(.trailing, Constants.inset + style.insets.trailing)
    }
    
    private var disabledIcon: some View {
        Image(systemName: "lock.fill")
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
    
    /// Method allows to change the date format from Date to String.
    private func dateToString(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    /// Method allows to change the date format from String to Date.
    private func stringToDate(_ string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
    
    /// Method allows to validate the picker field.
    private func validate(selection: Any? = nil, isFocused: Bool? = nil) {
        SWValidationHelper.validateFieldPicker(
            selection: selection ?? self.selection,
            state: &state,
            isRequired: style.required,
            isFocused: isFocused ?? self.isFocused,
            isDisabled: style.disabled.wrappedValue,
            wasTouched: wasTouched
        )
    }
}
