//
//  colorFunctions.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 09/07/2020.
//

import Foundation
import SwiftUI

/// Returns the color used for text (`.black` when light mode is enabled, `.white` when dark mode is enabled).
/// Works for macOS, iPadOS, and iOS
var labelColor: Color {
    #if os(macOS)
    return Color(.labelColor)
    #else
    return Color(.label)
    #endif
}

/// Returns the background color (`.black` when dark mode is enabled, `.white` when light mode is enabled).
/// Works for macOS, iPadOS, and iOS
var backgroundColor: Color {
    #if os(macOS)
    return Color(.textBackgroundColor)
    #else
    return Color(.systemBackground)
    #endif
}
