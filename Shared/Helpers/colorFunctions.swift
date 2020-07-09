//
//  colorFunctions.swift
//  iOS
//
//  Created by Alejandro Modroño Vara on 09/07/2020.
//

import Foundation
import SwiftUI

func labelColor() -> Color {

    #if os(iOS)
    return Color(.label)
    #else
    return Color(.labelColor)
    #endif

}
