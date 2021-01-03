//
//  screenAndWindowSize.swift
//  Starlight
//
//  Created by Alejandro Modroño Vara on 5/8/20.
//

import Foundation

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

#if os(iOS)
var screen = UIScreen.self
#else
var screen = NSWindow.self
#endif
