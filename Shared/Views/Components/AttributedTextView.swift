//
//  AttributedTextView.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/16/20.
//

import SwiftUI
import Foundation
import Atributika

#if canImport(UIKit)

import UIKit

// Note: Implementation pulled from pending PR in Atributika on GitHub: https://github.com/psharanda/Atributika/pull/119
// Credit to rivera-ernesto for this implementation.
/// A view that displays one or more lines of text with applied styles.
struct AttributedTextView: UIViewRepresentable {
    typealias UIViewType = RestrainedLabel

    /// The attributed text for this view.
    var attributedText: AttributedText?

    /// The configuration properties for this view.
    var configured: ((AttributedLabel) -> Void)?

    @State var maxWidth: CGFloat = UIScreen.main.bounds.width

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

struct RenderedText: View {

    /// The attributed text for this view.
    var text: String

    /// The text size
    var fontSize: CGFloat

    @State private var width: CGFloat = 0

    var negativePadding: CGFloat = 0

    var body: some View {

        let all: Style = Style.font(
            .systemFont(
                ofSize: self.fontSize,
                weight: .regular
            )
        )

        let link: Style = Style("a")
            .foregroundColor(#colorLiteral(red: 0.6050000191, green: 0.3829999864, blue: 1, alpha: 1), .normal)
            .foregroundColor(#colorLiteral(red: 0.6672357917, green: 0.5761700273, blue: 1, alpha: 1), .highlighted) // Now this style will be clickable
            .foregroundColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), .disabled)

        let configureLabel: ((AttributedLabel) -> Void) = { label in
            label.numberOfLines = 0
            label.textColor = .label
            label.onClick = { label, detection in
                switch detection.type {
                case .hashtag(let tag):
                    if let url = URL(string: "https://mastodon.social/hashtag/\(tag)") {
                        openUrl(url)
                    }
                case .mention(let name):
                    if let url = URL(string: "https://mastodon.social/\(name)") {
                        openUrl(url)
                    }
                case .link(let url):
                    openUrl(url)

                case .tag(let tag):
                    if tag.name == "a", let href = tag.attributes["href"], let url = URL(string: href) {
                        openUrl(url)
                    }
                default:
                    break
                }
            }
        }

        #if os(macOS)
        // Note: Need to subtract sidebar size here.
        let bounds: CGFloat = NSApplication.shared.mainWindow?.frame.width
        #else
        let bounds: CGFloat = UIScreen.main.bounds.width - negativePadding
        #endif

        return VStack {
            
            AttributedTextView(attributedText: text
                                .style(tags: link)
                                .styleHashtags(link)
                                .styleMentions(link)
                                .styleLinks(link)
                                .styleAll(all), configured: configureLabel, maxWidth: bounds
            )
            .fixedSize(
                horizontal: true,
                vertical: true
            )
        }
    }
}

#else

import AppKit

struct RenderedText: NSViewRepresentable {

    /// The attributed text for this view.
    var attributedText: String

    /// The text size
    var fontSize: CGFloat

    typealias NSViewType = NSView

    func makeNSView(context: Self.Context) -> NSView {

        let view = NSView()
        let attributedLabel = AttributedLabel()

        attributedLabel.numberOfLines = 0
        attributedLabel.textColor = .label
        attributedLabel.lineBreakMode = .byWordWrapping

        let all: Style = Style.font(
            .systemFont(
                ofSize: self.fontSize,
                weight: .regular
            )
        )

        let link: Style = Style("a")
            .foregroundColor(#colorLiteral(red: 0.6050000191, green: 0.3829999864, blue: 1, alpha: 1), .normal)
            .foregroundColor(#colorLiteral(red: 0.6672357917, green: 0.5761700273, blue: 1, alpha: 1), .highlighted) // Now this style will be clickable
            .foregroundColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), .disabled)

        attributedLabel.attributedText = self.attributedText
            .style(tags: link)
            .styleHashtags(link)
            .styleMentions(link)
            .styleLinks(link)
            .styleAll(all)

        attributedLabel.onClick = { label, detection in
                    switch detection.type {
                    case .hashtag(let tag):
                        if let url = URL(string: "https://mastodon.social/hashtag/\(tag)") {
                            openUrl(url)
                        }
                    case .mention(let name):
                        if let url = URL(string: "https://mastodon.social/\(name)") {
                            openUrl(url)
                        }
                    case .link(let url):
                        openUrl(url)

                    case .tag(let tag):
                        if tag.name == "a", let href = tag.attributes["href"], let url = URL(string: href) {
                            openUrl(url)
                        }
                    default:
                        break
                    }
                }

        view.addSubview(attributedLabel)
        return view
    }

    func updateNSView(_ nsView: NSView, context: Self.Context) {
    }

}

#endif


struct AttributedTextView_Previews: PreviewProvider {
    static var previews: some View {
        RenderedText(text: "Hello there.<br>@General #Kenobi", fontSize: 20)
    }
}
