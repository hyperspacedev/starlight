//
//  History.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/7/20.
//

import Foundation

/// A class representation of a tag's history.
public class History: Codable, Identifiable {

    /// The ID associated with this history event.
    // swiftlint:disable:next identifier_name
    public let id = UUID()

    /// The weekday that this history event occurs on.
    public let day: String

    /// The number of times a tag was used on this day.
    public let uses: Int

    /// The number of accounts that used this tag on this day.
    public let accounts: Int
}
