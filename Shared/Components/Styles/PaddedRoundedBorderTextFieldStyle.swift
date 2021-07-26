//
//  PaddedRoundedBorderTextFieldStyle.swift
//  PaddedRoundedBorderTextFieldStyle
//
//  Created by Marquis Kurt on 26/7/21.
//

import SwiftUI

struct PaddedRoundedBorderTextFieldStyle: TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .textFieldStyle(.plain)
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 5).strokeBorder(.selection, lineWidth: 1))
    }
}

extension TextFieldStyle where Self == PaddedRoundedBorderTextFieldStyle {
    static var paddedRoundedBorder: Self {
        PaddedRoundedBorderTextFieldStyle()
    }
}
