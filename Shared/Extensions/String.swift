//
//  String.swift
//  String
//
//  Created by Marquis Kurt on 24/7/21.
//

import Foundation
import Chica

extension String {
    /// Returns a Markdown-compatible version of itself that replaces emoji shortcodes with images or emojis.
    ///
    /// Emoji shortcodes are defined with a surrounding pair of colons.
    func emojified() -> String { emojifyRecursive(from: self) }
    
    private func emojifyRecursive(from point: String) -> String {
        guard let regexRanges = point.range(of: #":([a-zA-Z_\-0-9]+):"#, options: [.regularExpression, .caseInsensitive]) else {
            return point
        }
        
        // FIXME: Implement a dictionary lookup for replacing emojis!
        return emojifyRecursive(from: point.replacingOccurrences(of: point[regexRanges], with: ""))
    }
    
    /// Returns a Markdown-parsed version of an HTML string.
    func toMarkdown() -> AttributedString {
        var markdown = self
        
        let primitives = ["p" : "\n", "br" : "\n\n", "a": "", "span" : ""]
        primitives.forEach { key, value in markdown = markdown.replaceAttributedTag(key, with: value, in: markdown) }
        
        let symbols = ["&quot;" : "\"", "&apos;": "'", "&gt;": ">", "&lt;": "<"]
        symbols.forEach { key, value in markdown = markdown.replacingOccurrences(of: key, with: value) }
        
        do {
            return try AttributedString(markdown: markdown)
        } catch {
            return AttributedString()
        }
    }
    
    private func replacePrimitiveTag(_ tag: String, with replacedString: String, in text: String = "") -> String {
        guard let ranges = text.range(of: #"</?\#(tag)>"#, options: [.regularExpression]) else {
            return text
        }
        
        return replacePrimitiveTag(tag, with: replacedString, in: text.replacingOccurrences(of: text[ranges], with: replacedString))
    }
    
    private func replaceAttributedTag(_ tag: String, with replacedString: String, in text: String = "") -> String {
        guard let ranges = text.range(
            of: #"</?\#(tag)(\s(\w+)="([a-zA-Z0-9\:\/-_.\s]*)")*>"#,
            options: [.regularExpression]
        ) else { return text }
        return replaceAttributedTag(tag, with: replacedString, in: text.replacingOccurrences(of: text[ranges], with: replacedString))
    }
}
