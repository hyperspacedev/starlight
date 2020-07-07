//
//  Tag.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/7/20.
//

import Foundation

/// A class representation of a hashtag.
public class Tag: Codable, Identifiable {

    /// The ID associated with this tag.
    // swiftlint:disable:next identifier_name
    public let id = UUID()

    /// The name of the tag.
    public let name: String

    /// The URL to access posts with this tag.
    public let url: String

    /// The weekly history of this tag.
    public let history: [History]?
}
