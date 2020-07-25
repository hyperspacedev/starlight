//
//  AttributedTextView.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/16/20.
//

#if canImport(UIKit)
import UIKit
import SwiftUI
import Foundation
import Atributika

// Note: Implementation pulled from pending PR in Atributika on GitHub: https://github.com/psharanda/Atributika/pull/119
// Credit to rivera-ernesto for this implementation.

/// A view that displays one or more lines of text with applied styles.
struct AttributedTextView: UIViewRepresentable {
    typealias UIViewType = RestrainedLabel

    /// The attributed text for this view.
    var attributedText: AttributedText?

    /// The configuration properties for this view.
    var configured: ((AttributedLabel) -> Void)?

    @State var maxWidth: CGFloat = 300

    public func makeUIView(context: UIViewRepresentableContext<AttributedTextView>) -> RestrainedLabel {
        let new = RestrainedLabel()
        configured?(new)
        return new
    }

    public func updateUIView(_ uiView: RestrainedLabel, context: UIViewRepresentableContext<AttributedTextView>) {
        uiView.attributedText = attributedText
        uiView.maxWidth = maxWidth
    }

    class RestrainedLabel: AttributedLabel {
        var maxWidth: CGFloat = 0.0

        open override var intrinsicContentSize: CGSize {
            sizeThatFits(CGSize(width: maxWidth, height: .infinity))
        }
    }

}
#endif
