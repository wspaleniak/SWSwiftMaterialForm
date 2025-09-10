//
//  SWFieldStyle.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 20/07/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import SwiftUI

public struct SWFieldStyle {
    
    /// The field placeholder text if different from field title.
    public fileprivate(set) var placeholder: String? = nil
    
    /// The configuration of the main field properties.
    public fileprivate(set) var configuration: SWFieldStyleConfiguration = .border
    
    /// The standard built-in validator for the field.
    /// You can choose one of the predefined validators.
    public fileprivate(set) var standardValidator: SWStandardValidator? = nil
    
    /// The custom validator for the field.
    /// You can use your validator outside the framework.
    /// The only information the framework needs is whether the validation was successful or not.
    /// If not you can pass an error message.
    public fileprivate(set) var customValidator: SWCustomValidator? = nil
    
    /// Whether the field is required.
    public fileprivate(set) var required: SWValidationRequired = .notRequired
    
    /// The force validation of the field.
    public fileprivate(set) var forceValidation: Binding<Bool> = .constant(false)
    
    /// The custom error message for the field e.g. when receiving an error from the server.
    public fileprivate(set) var customErrorMessage: Binding<String> = .constant("")
    
    /// Whether the field text is secured and visible as dots.
    public fileprivate(set) var secureText: SWFieldStyleSecureText? = nil
    
    /// The text limit for the field.
    public fileprivate(set) var limitText: Int? = nil
    
    /// The height of the field.
    public fileprivate(set) var height: CGFloat? = nil
    
    /// The insets of the field.
    public fileprivate(set) var insets: EdgeInsets = .init(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0)
    
    /// Whether the field is disabled.
    public fileprivate(set) var disabled: Binding<Bool> = .constant(false)
    
    /// The custom icon used when the field is disabled.
    public fileprivate(set) var disabledIcon: Image? = nil
    
    /// The custom icon for the picker field.
    public fileprivate(set) var pickerIcon: Image? = nil
    
    /// Additional view from the left side of the field.
    public fileprivate(set) var extraView: AnyView? = nil
}

extension EnvironmentValues {
    @Entry var fieldStyle = SWFieldStyle()
}

public protocol SWFieldStyleValue {
    associatedtype Value
    var keyPath: WritableKeyPath<SWFieldStyle, Value> { get }
}

extension View {
    public func fieldStyle<T: SWFieldStyleValue>(_ key: T, _ value: T.Value) -> some View {
        transformEnvironment(\.fieldStyle) { fieldStyle in
            fieldStyle[keyPath: key.keyPath] = value
        }
    }
}

// MARK: - Placeholder

public struct PlaceholderSWFieldStyleValue: SWFieldStyleValue {
    public var keyPath: WritableKeyPath<SWFieldStyle, String?> { \.placeholder }
}
extension SWFieldStyleValue where Self == PlaceholderSWFieldStyleValue {
    public static var placeholder: Self { PlaceholderSWFieldStyleValue() }
}

// MARK: - Configuration

public struct ConfigurationSWFieldStyleValue: SWFieldStyleValue {
    public var keyPath: WritableKeyPath<SWFieldStyle, SWFieldStyleConfiguration> { \.configuration }
}
extension SWFieldStyleValue where Self == ConfigurationSWFieldStyleValue {
    public static var configuration: Self { ConfigurationSWFieldStyleValue() }
}

// MARK: - Standard validator

public struct StandardValidatorSWFieldStyleValue: SWFieldStyleValue {
    public var keyPath: WritableKeyPath<SWFieldStyle, SWStandardValidator?> { \.standardValidator }
}
extension SWFieldStyleValue where Self == StandardValidatorSWFieldStyleValue {
    public static var standardValidator: Self { StandardValidatorSWFieldStyleValue() }
}

// MARK: - Custom validator

public struct CustomValidatorSWFieldStyleValue: SWFieldStyleValue {
    public var keyPath: WritableKeyPath<SWFieldStyle, SWCustomValidator?> { \.customValidator }
}
extension SWFieldStyleValue where Self == CustomValidatorSWFieldStyleValue {
    public static var customValidator: Self { CustomValidatorSWFieldStyleValue() }
}

// MARK: - Required

public struct RequiredSWFieldStyleValue: SWFieldStyleValue {
    public var keyPath: WritableKeyPath<SWFieldStyle, SWValidationRequired> { \.required }
}
extension SWFieldStyleValue where Self == RequiredSWFieldStyleValue {
    public static var required: Self { RequiredSWFieldStyleValue() }
}

// MARK: - Force validation

public struct ForceValidationSWFieldStyleValue: SWFieldStyleValue {
    public var keyPath: WritableKeyPath<SWFieldStyle, Binding<Bool>> { \.forceValidation }
}
extension SWFieldStyleValue where Self == ForceValidationSWFieldStyleValue {
    public static var forceValidation: Self { ForceValidationSWFieldStyleValue() }
}

// MARK: - Custom error message

public struct CustomErrorMessageSWFieldStyleValue: SWFieldStyleValue {
    public var keyPath: WritableKeyPath<SWFieldStyle, Binding<String>> { \.customErrorMessage }
}
extension SWFieldStyleValue where Self == CustomErrorMessageSWFieldStyleValue {
    public static var customErrorMessage: Self { CustomErrorMessageSWFieldStyleValue() }
}

// MARK: - Secure text

public struct SecureTextSWFieldStyleValue: SWFieldStyleValue {
    public var keyPath: WritableKeyPath<SWFieldStyle, SWFieldStyleSecureText?> { \.secureText }
}
extension SWFieldStyleValue where Self == SecureTextSWFieldStyleValue {
    public static var secureText: Self { SecureTextSWFieldStyleValue() }
}

// MARK: - Limit text

public struct LimitTextSWFieldStyleValue: SWFieldStyleValue {
    public var keyPath: WritableKeyPath<SWFieldStyle, Int?> { \.limitText }
}
extension SWFieldStyleValue where Self == LimitTextSWFieldStyleValue {
    public static var limitText: Self { LimitTextSWFieldStyleValue() }
}

// MARK: - Height

public struct HeightSWFieldStyleValue: SWFieldStyleValue {
    public var keyPath: WritableKeyPath<SWFieldStyle, CGFloat?> { \.height }
}
extension SWFieldStyleValue where Self == HeightSWFieldStyleValue {
    public static var height: Self { HeightSWFieldStyleValue() }
}

// MARK: - Insets

public struct InsetsSWFieldStyleValue: SWFieldStyleValue {
    public var keyPath: WritableKeyPath<SWFieldStyle, EdgeInsets> { \.insets }
}
extension SWFieldStyleValue where Self == InsetsSWFieldStyleValue {
    public static var insets: Self { InsetsSWFieldStyleValue() }
}

// MARK: - Disabled

public struct DisabledSWFieldStyleValue: SWFieldStyleValue {
    public var keyPath: WritableKeyPath<SWFieldStyle, Binding<Bool>> { \.disabled }
}
extension SWFieldStyleValue where Self == DisabledSWFieldStyleValue {
    public static var disabled: Self { DisabledSWFieldStyleValue() }
}

// MARK: - Disabled icon

public struct DisabledIconSWFieldStyleValue: SWFieldStyleValue {
    public var keyPath: WritableKeyPath<SWFieldStyle, Image?> { \.disabledIcon }
}
extension SWFieldStyleValue where Self == DisabledIconSWFieldStyleValue {
    public static var disabledIcon: Self { DisabledIconSWFieldStyleValue() }
}

// MARK: - Picker icon

public struct PickerIconSWFieldStyleValue: SWFieldStyleValue {
    public var keyPath: WritableKeyPath<SWFieldStyle, Image?> { \.pickerIcon }
}
extension SWFieldStyleValue where Self == PickerIconSWFieldStyleValue {
    public static var pickerIcon: Self { PickerIconSWFieldStyleValue() }
}

// MARK: - Extra view

public struct ExtraViewSWFieldStyleValue: SWFieldStyleValue {
    public var keyPath: WritableKeyPath<SWFieldStyle, AnyView?> { \.extraView }
}
extension SWFieldStyleValue where Self == ExtraViewSWFieldStyleValue {
    public static var extraView: Self { ExtraViewSWFieldStyleValue() }
}
