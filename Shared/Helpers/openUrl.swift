//
//  openUrl.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 12/07/2020.
//

import Foundation
import UIKit

/// Opens a URL on the preferred browser on macOS, iPadOS, and iOS.
///
/// - Parameters:
///     - url: The url to be opened, as a ``String``.
func openUrl(_ url: String) {
    #if os(macOS)
    if NSWorkspace.shared.open(URL(string: url)!) {
        print("default browser was successfully opened")
    }
    #else
    UIApplication.shared.open(URL(string: url)!)
    #endif
}

/// Opens a URL on the preferred browser on macOS, iPadOS, and iOS.
///
/// - Parameters:
///     - url: The url to be opened, as a ``URL``.
func openUrl(_ url: URL) {
    #if os(macOS)
    if NSWorkspace.shared.open(url) {
        print("default browser was successfully opened")
    }
    #else
    UIApplication.shared.open(url)
    #endif
}
