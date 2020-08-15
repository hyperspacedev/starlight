//
//  conditionalModifiers.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 3/8/20.
//

import Foundation
import SwiftUI

extension View {
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            return AnyView(content(self))
        } else {
            return AnyView(self)
        }
    }
}
