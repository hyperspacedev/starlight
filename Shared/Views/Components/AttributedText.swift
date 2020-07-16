//
//  AttributedText.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/16/20.
//

import Down
import UIKit
import SwiftUI
import Foundation

public struct AttributedText: UIViewRepresentable {
    public typealias UIViewType = UILabel
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
