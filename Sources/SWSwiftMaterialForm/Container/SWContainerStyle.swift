//
//  SWContainerStyle.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 19/07/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import SwiftUI

public struct SWContainerStyle {
    
    /// Whether the form should focused the first field and after what time (in seconds).
    var startWithFocusedFieldAfter: Int = 0
    
    /// If some field in the container is focused, it allows to unfocus it.
    /// You can use it e.g. for hide the keyboard when the user taps on the background.
    var unfocusFields: Binding<Bool> = .constant(false)
    
    /// The list of indexes of fields with errors.
    var erroredFields: Binding<[Int]> = .constant([])
    
    /// The animation type for animating fields in the container.
    var animation: Animation? = .smooth
    
    /// The color of the container background.
    var backgroundColor: Color = Color(uiColor: .systemBackground)
    
    /// Whether the toolbar is visible.
    var toolbarVisible: Bool = true
    
    /// The title of the action button on the toolbar.
    var toolbarButtonTitle: String = "Done"
    
    /// The color of elements on the toolbar.
    var toolbarTintColor: Color = .primary
    
    /// The size of elements on the toolbar.
    var toolbarFont: Font = .body
}

struct SWContainerStyleKey: EnvironmentKey {
    static let defaultValue = SWContainerStyle()
}

extension EnvironmentValues {
    var containerStyle: SWContainerStyle {
        get { self[SWContainerStyleKey.self] }
        set { self[SWContainerStyleKey.self] = newValue }
    }
}

public protocol SWContainerStyleValue {
    associatedtype Value
    var keyPath: WritableKeyPath<SWContainerStyle, Value> { get }
}

extension View {
    public func containerStyle<T: SWContainerStyleValue>(key: T, _ value: T.Value) -> some View {
        transformEnvironment(\.containerStyle) { containerStyle in
            containerStyle[keyPath: key.keyPath] = value
        }
    }
}

// MARK: - Start with focused field

public struct StartWithFocusedFieldAfterSWContainerStyleValue: SWContainerStyleValue {
    public var keyPath: WritableKeyPath<SWContainerStyle, Int> { \.startWithFocusedFieldAfter }
}
extension SWContainerStyleValue where Self == StartWithFocusedFieldAfterSWContainerStyleValue {
    public static var startWithFocusedFieldAfter: Self { StartWithFocusedFieldAfterSWContainerStyleValue() }
}

// MARK: - Unfocus fields

public struct UnfocusSWContainerStyleValue: SWContainerStyleValue {
    public var keyPath: WritableKeyPath<SWContainerStyle, Binding<Bool>> { \.unfocusFields }
}
extension SWContainerStyleValue where Self == UnfocusSWContainerStyleValue {
    public static var unfocusFields: Self { UnfocusSWContainerStyleValue() }
}

// MARK: - Errored fields

public struct ErroredFieldsSWContainerStyleValue: SWContainerStyleValue {
    public var keyPath: WritableKeyPath<SWContainerStyle, Binding<[Int]>> { \.erroredFields }
}
extension SWContainerStyleValue where Self == ErroredFieldsSWContainerStyleValue {
    public static var erroredFields: Self { ErroredFieldsSWContainerStyleValue() }
}

// MARK: - Animation

public struct AnimationSWContainerStyleValue: SWContainerStyleValue {
    public var keyPath: WritableKeyPath<SWContainerStyle, Animation?> { \.animation }
}
extension SWContainerStyleValue where Self == AnimationSWContainerStyleValue {
    public static var animation: Self { AnimationSWContainerStyleValue() }
}

// MARK: - Background color

public struct BackgroundColorSWContainerStyleValue: SWContainerStyleValue {
    public var keyPath: WritableKeyPath<SWContainerStyle, Color> { \.backgroundColor }
}
extension SWContainerStyleValue where Self == BackgroundColorSWContainerStyleValue {
    public static var backgroundColor: Self { BackgroundColorSWContainerStyleValue() }
}

// MARK: - Toolbar visible

public struct ToolbarVisibleSWContainerStyleValue: SWContainerStyleValue {
    public var keyPath: WritableKeyPath<SWContainerStyle, Bool> { \.toolbarVisible }
}
extension SWContainerStyleValue where Self == ToolbarVisibleSWContainerStyleValue {
    public static var toolbarVisible: Self { ToolbarVisibleSWContainerStyleValue() }
}

// MARK: - Toolbar button title

public struct ToolbarButtonTitleSWContainerStyleValue: SWContainerStyleValue {
    public var keyPath: WritableKeyPath<SWContainerStyle, String> { \.toolbarButtonTitle }
}
extension SWContainerStyleValue where Self == ToolbarButtonTitleSWContainerStyleValue {
    public static var toolbarButtonTitle: Self { ToolbarButtonTitleSWContainerStyleValue() }
}

// MARK: - Toolbar tint color

public struct ToolbarTintColorSWContainerStyleValue: SWContainerStyleValue {
    public var keyPath: WritableKeyPath<SWContainerStyle, Color> { \.toolbarTintColor }
}
extension SWContainerStyleValue where Self == ToolbarTintColorSWContainerStyleValue {
    public static var toolbarTintColor: Self { ToolbarTintColorSWContainerStyleValue() }
}

// MARK: - Toolbar font

public struct ToolbarFontSWContainerStyleValue: SWContainerStyleValue {
    public var keyPath: WritableKeyPath<SWContainerStyle, Font> { \.toolbarFont }
}
extension SWContainerStyleValue where Self == ToolbarFontSWContainerStyleValue {
    public static var toolbarFont: Self { ToolbarFontSWContainerStyleValue() }
}
