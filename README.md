# Material Forms for SwiftUI

[![SwiftPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
[![license MIT](https://img.shields.io/cocoapods/l/JZCalendarWeekView.svg)](http://opensource.org/licenses/MIT)

*SWSwiftMaterialForm* is library for iOS 15.0+ that allows to create forms with Material style in SwiftUI.

<p align="center">
  <img src="https://github.com/user-attachments/assets/9d12ab41-c7cd-4ee4-be89-482386fe05f1" width="268"> <img src="https://github.com/user-attachments/assets/67357825-64ef-44af-8e3a-83cf97a45843" width="268"> <img src="https://github.com/user-attachments/assets/7cf88c97-abec-47eb-b679-1a5a44705fb5" width="268">
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/588700c9-f689-4b8d-9875-50574deaf0bc" width="200"> <img src="https://github.com/user-attachments/assets/a778e258-cb07-49f7-967a-7931a74d9a75" width="200"> <img src="https://github.com/user-attachments/assets/acf688e3-262f-43b5-96fa-8f77b35a9e3b" width="200"> <img src="https://github.com/user-attachments/assets/c1e8d3a4-80d3-4262-a9f6-979d86fbad6a" width="200"> <img src="https://github.com/user-attachments/assets/6e256578-d5a5-45c1-ac13-173c209117b2" width="200"> <img src="https://github.com/user-attachments/assets/6e11fa8d-67a0-4662-9d08-747b26ac5877" width="200"> <img src="https://github.com/user-attachments/assets/6b214237-746c-4680-890d-bbee4c35eb74" width="200"> <img src="https://github.com/user-attachments/assets/38e97053-2868-469f-869f-a8956f160a38" width="200">
</p>

## Installation

To install *SWSwiftMaterialForm* in your project follow the steps below:
1. In Xcode, select “File” → “Add Packages...”
2. Enter https://github.com/wspaleniak/SWSwiftMaterialForm.git

Or add following dependency to your `Package.swift`:

```swift
.package(url: "https://github.com/wspaleniak/SWSwiftMaterialForm.git", .upToNextMajor(from: "1.0.3"))
```

## How to use

If you want to check how the library works, you can clone the repository [ExampleApp](https://github.com/wspaleniak/SWSwiftMaterialFormExample).</br>
If you want to use the library, import it in your project using `import SWSwiftMaterialForm`.

## Container

### SWContainer

In *SWSwiftMaterialForm*, you can use a `SWContainer` just like `VStack` in SwiftUI. You can place any `View` object there. All fields available in the library or created like them register in the `SWContainer`. Thanks to this, you can easily jump between fields using the toolbar above the keyboard or under the picker field. The `SWContainer` provides information about whether the form has any errors, which fields report an error or which field is currently selected.

```swift
@ScaledMetric
private var spacing: CGFloat = 18.0

@State
private var hasErrors: Bool = false

SWContainer(
  spacing: spacing, // Spacing between fields in the container.
  errors: $hasErrors // Whether the container has field with an error.
) {
  // Fields
}
```

### SWContainerStyle

The `SWContainer` has dedicated modifiers `.containerStyle(key:value:)` that allow you to customize its appearance. All keys have default values ​​assigned to them, which you can change freely. Please refer to the `SWContainerStyle` file for more details.

```swift
@State
private var focusedFieldID: Int? = nil

@State
private var unfocusFields: Bool = false

@State
private var erroredFields: [Int] = []

SWContainer {
  // Fields
}
.containerStyle(.startWithFocusedFieldAfter, 2) // Select the first field with the given delay.
.containerStyle(.focusedFieldID, $focusedFieldID) // Index of the selected field.
.containerStyle(.unfocusFields, $unfocusFields) // Allows to deselect the selected field.
.containerStyle(.erroredFields, $erroredFields) // Array of fields that contain an error.
.containerStyle(.animation, .bouncy) // Animation for the container and all fields.
.containerStyle(.backgroundColor, .yellow) // Set the same color as the background of the view under the container.
.containerStyle(.toolbarVisible, true) // Allows to hide the toolbar.
.containerStyle(.toolbarButtonTitle, "Done") // Title of the button on the toolbar.
.containerStyle(.toolbarTintColor, .red) // Color of elements on the toolbar.
.containerStyle(.toolbarFont, .headline) // Font of elements on the toolbar.
```

## Fields

There are 4 predefined fields in *SWSwiftMaterialForm*: `SWTextField`, `SWTextEditor`, `SWPicker` and `SWDatePicker`. Most types in the library are marked as `public` - so you can create your own field using the same types as the predefined fields.

Each field has its own state `SWFieldState`, which depends on many factors, e.g. field validation. The colors of the field depend on the field state and are configurable - you can set a different color for each state. Please refer to the `SWFieldStyleColors` file for more details.

The height of the field is dynamic - it increases with the font size. The minimum field height is based on the font height and inner insets and is a priority. Therefore, setting the height too low will be ignored. Please refer to the `SWFieldStyleFonts` file for more details.

**IMPORTANT: Each predefined field must be contained in the `SWContainer` because the field references the `SWContainerViewModel` via `@EnvironmentObject`. Otherwise the application will crash.**

### SWTextField

```swift
@State
private var nameText: String = ""

SWTextField(
  title: "Your name", // Label title and placeholder title.
  text: $nameText // Text entered into the field.
)
```

### SWTextEditor

```swift
@State
private var storyText: String = ""

SWTextEditor(
  title: "Your story", // Label title and placeholder title.
  text: $storyText // Text entered into the field.
)
```

### SWPicker

```swift
@State
private var animalSelection: Int? = nil

private let animals: [String] = [
  "Dog", "Cat", "Tiger", "Lion", "Bird", "Mouse"
]

SWPicker(
  title: "Your animal", // Label title and placeholder title.
  data: animals, // Array of string options for the picker.
  selection: $animalSelection // Index of the selected option from the picker.
)
```

### SWDatePicker

```swift
@State
private var dateSelection: String? = nil

SWDatePicker(
  title: "Your birthday", // Label title and placeholder title.
  type: .date(format: "dd-MM-yyyy"), // Picker type with string formatter. Available types: .date(), .hour(), .dateAndHour().
  selection: $dateSelection // Selected date in string format.
)
```

### SWFieldStyle

In *SWSwiftMaterialForm*, each field has dedicated modifiers `.fieldStyle(key:value:)` that allow you to customize its appearance. All keys have default values ​​assigned to them, which you can change freely. Please refer to the `SWFieldStyle` file for more details.

```swift
@State
private var loginText: String = ""

@State
private var loginErrorText: String = ""

@State
private var isDisabled: Bool = false

@State
private var forceValidation: Bool = false

SWTextField(
  title: "Login",
  text: $loginText
)
.fieldStyle(.placeholder, "Name (optional)") // Custom placeholder if different from field title.
.fieldStyle(.configuration, .comboShadow) // Configuration of the field appearance.
.fieldStyle(.standardValidator, .login) // Standard field validator.
.fieldStyle(.required, .required(message: "Your login is required.")) // Whether the field is required.
.fieldStyle(.forceValidation, $forceValidation) // Allows to force validation of the field.
.fieldStyle(.customErrorMessage, $loginErrorText) // Allows to set custom error message for the field.
.fieldStyle(.secureText, false) // Allows to hide text in the field.
.fieldStyle(.limitText, 32) // Allows to limit text in the field.
.fieldStyle(.height, 48) // Height of the field.
.fieldStyle(.insets, .init(top: 8, leading: 8, bottom: 8, trailing: 8)) // Inner insets in the field.
.fieldStyle(.disabled, $isDisabled) // Whether the field is disabled.
.fieldStyle(.disabledIcon, Image(systemName: "lock.fill")) // Custom icon used when the field is disabled.
.fieldStyle(.pickerIcon, Image(systemName: "chevron.down")) // Custom icon for the picker field.
.fieldStyle(.extraView, AnyView(...)) // Additional view from the left side of the field.
```

### SWFieldStyleConfiguration

In *SWSwiftMaterialForm* you can create your own field appearance configuration. To create your own configuration, you can create an object of the `SWFieldStyleConfiguration` type or extend it and create a static variable.

Inside the `SWFieldStyleConfiguration` object, you can set the colors of the field elements for its different states using `SWFieldStyleColors`. You can set the field fonts for *field label*, *placeholder/entered text*, and *error label* objects using `SWFieldStyleFonts`. You can set the shadow values ​​for a field using `SWFieldStyleShadow`. Please refer to the `SWFieldStyleConfiguration` file for more details.

You can use the created configuration using the modifier `.fieldStyle(.configuration, .special)`.

```swift
extension SWFieldStyleConfiguration {
  static let special = SWFieldStyleConfiguration(
    colors: .standard, // Field colors for different states.
    fonts: .standard, // Fonts for labels, text and placeholder.
    shadow: .standard, // Shadow of the field.
    shadowVisible: true, // Whether the field shadow is visible.
    backgroundVisible: true, // Whether the field background is visible.
    underlineVisible: true, // Whether the underline is visible when the field is active.
    strokeWidth: 1.0, // Width of the field stroke.
    cornerRadius: 8.0 // Field corner radius.
  )
}
```

### SWStandardValidator

*SWSwiftMaterialForm* has a standard validator that allows you to check text based on a given regular expression. There are 2 predefined validators for login and email. To create your own standard validator, you can create an object of the `SWStandardValidator` type or extend it and create a static variable. 

You can use the created validator using the modifier `.fieldStyle(.standardValidator, .username)`.

```swift
extension SWStandardValidator {
  static let username = SWStandardValidator(
    regex: "^[\w\d_.]{4,}$", // Validator regular expression.
    message: "The entered username is incorrect." // Message when the entered text does not match the regular expression.
  )
}
```

### SWCustomValidator

In *SWSwiftMaterialForm* you can use your own validators and pass their result to selected fields. The `SWCustomValidator` type is actually a typealias for `(String) -> SWValidationResult`. If the field validation passed you can return `.ok`, in any other case return `.error(message:)` along with the error message. 

You can use the created validator using the modifier `.fieldStyle(.customValidator, nameValidator)`.

```swift
let nameValidator: SWCustomValidator = { text in
  switch text.count {
  case 0..<3: .error(message: "Your name is too short...")
  case 3...5: .error(message: "Give us more letters bro XD")
  default: .ok
  }
}
```

## Author

Wojciech Spaleniak - ws92developer@gmail.com </br>
If you have any questions and suggestions, feel free to contact me.
