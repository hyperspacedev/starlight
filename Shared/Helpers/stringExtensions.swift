//
//  stringExtensions.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 22/07/2020.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }

//    func stripHTML() -> String {
//
//        var content = self
//        print(content)
//
//        let regex = [
//            "</p><p>": "\n\n",
//            "<br />": "\n",
//            "<[^>]+>": "",
//            "&apos;": "'",
//            "&quot;": "\"",
//            "&amp;": "&",
//            "&nbsp;": " ",
//            "&lt;": "<",
//            "&gt;": ">",
//            "&#39;": "'",
//        ]
//
//        for (_, keyValue) in regex.enumerated() {
//            print("replacing \(keyValue.key) with \(keyValue.value)")
//            content = self.replacingOccurrences(
//                of: "\(keyValue.key)",
//                with: "\(keyValue.value)",
//                options: NSString.CompareOptions.regularExpression,
//                range: nil)
//        }
//
//        print("result: \(content)")
//
//        return content
//    }

    func stripHTML() -> String {

        let content = self.replacingOccurrences(
            of: "</p><p>", with: "\n\n",
            options: NSString.CompareOptions.regularExpression,
            range: nil)

//        content = content.replacingOccurrences(
//            of: "<br />",
//            with: "\n",
//            options: NSString.CompareOptions.regularExpression,
//            range: nil)
//
//        content = content.replacingOccurrences(
//            of: "<[^>]+>",
//            with: "",
//            options: NSString.CompareOptions.regularExpression,
//            range: nil)
//
//        content = content.replacingOccurrences(
//            of: "&apos;",
//            with: "'",
//            options: NSString.CompareOptions.regularExpression,
//            range: nil)
//
//        content = content.replacingOccurrences(
//            of: "&quot;",
//            with: "\"",
//            options: NSString.CompareOptions.regularExpression,
//            range: nil)
//
//        content = content.replacingOccurrences(
//            of: "&amp;",
//            with: "&",
//            options: NSString.CompareOptions.regularExpression,
//            range: nil)
//
//        content = content.replacingOccurrences(
//            of: "&nbsp;",
//            with: " ",
//            options: NSString.CompareOptions.regularExpression,
//            range: nil)
//
//        content = content.replacingOccurrences(
//            of: "&lt;",
//            with: "<",
//            options: NSString.CompareOptions.regularExpression,
//            range: nil)
//
//        content = content.replacingOccurrences(
//            of: "&gt;",
//            with: ">",
//            options: NSString.CompareOptions.regularExpression,
//            range: nil)
//
//        content = content.replacingOccurrences(
//            of: "&#39;",
//            with: "'",
//            options: NSString.CompareOptions.regularExpression,
//            range: nil)

        return content
    }

    func fixURL() -> String {

        var content = self.replacingOccurrences(
            of: "https://",
            with: "'",
            options: NSString.CompareOptions.regularExpression,
            range: nil)

        content = self.replacingOccurrences(
            of: "http://",
            with: "'",
            options: NSString.CompareOptions.regularExpression,
            range: nil)

        return content
    }

}
