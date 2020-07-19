//
//  AttributedText.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/16/20.
//

import UIKit
import SwiftUI
import Foundation

/// A view that displays one or more lines of readonly text with properties.
public struct AttributedText: UIViewRepresentable {
    public typealias UIViewType = UILabel
    
    /// The attributed string associated with this view.
    var attributedString: NSAttributedString

    public func makeUIView(context: UIViewRepresentableContext<AttributedText>) -> UILabel {
        let viewLabel = UILabel()
        viewLabel.numberOfLines = 0
        viewLabel.lineBreakMode = .byWordWrapping
        viewLabel.autoresizesSubviews = true
        viewLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewLabel.sizeToFit()
        return viewLabel
    }

    public func updateUIView(_ view: UILabel, context: UIViewRepresentableContext<AttributedText>) {
        view.attributedText = attributedString
        view.sizeToFit()
    }
}
