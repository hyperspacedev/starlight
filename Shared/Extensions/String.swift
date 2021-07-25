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
        guard let regexRanges = point.range(of: #":([a-zA-Z\_\-0-9]+):"#, options: [.regularExpression, .caseInsensitive]) else {
            return point
        }
        
        // FIXME: Implement a dictionary lookup for replacing emojis!
        return emojifyRecursive(from: point.replacingOccurrences(of: point[regexRanges], with: ""))
    }
}
