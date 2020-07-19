//
//  AttributedTextView.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/16/20.
//

import UIKit
import SwiftUI
import Foundation
import Atributika

// Note: Implementation pulled from pending PR in Atributika on GitHub: https://github.com/psharanda/Atributika/pull/119
// Credit to rivera-ernesto for this implementation.

/// A view that displays one or more lines of text with applied styles.
public struct AttributedTextView: UIViewRepresentable {
    public typealias UIViewType = AttributedLabel

    /// The attributed text for this view.
    var attributedText: AttributedText?

    /// The configuration properties for this view.
    var configured: ((AttributedLabel) -> Void)?

    public func makeUIView(context: UIViewRepresentableContext<AttributedTextView>) -> AttributedLabel {
        let new = AttributedLabel()
        configured?(new)
        return new
    }

    public func updateUIView(_ uiView: AttributedLabel, context: UIViewRepresentableContext<AttributedTextView>) {
        uiView.attributedText = attributedText
    }
}
