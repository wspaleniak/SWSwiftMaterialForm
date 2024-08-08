//
//  SWDatePickerType.swift
//  SWSwiftMaterialForm
//
//  Created by Wojciech Spaleniak on 02/08/2024.
//  Copyright © 2024 Wojciech Spaleniak. All rights reserved.
//

import Foundation

public enum SWDatePickerType {
    /// Only dates with the string format.
    case date(format: String = "dd.MM.yyyy")
    /// Only hours with the string format.
    case hour(format: String = "HH:mm")
    /// Both dates and hours with the string format.
    case dateAndHour(format: String = "dd.MM.yyyy HH:mm")
}
