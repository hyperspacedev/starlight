//
//  Instance.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/7/20.
//

import Foundation

/**
 A class representation of a fediverse instance.
 
 A fediverse instance is the server that the user lives on. The following class gives information
 about the instance and who can be contacted.
 */
public class Instance: Codable, Identifiable {

    /// The ID for this server.
    // swiftlint:disable:next identifier_name
    public let id = UUID()

    /// The website URI for this instance.
    public let uri: String

    /// The instance server's title or name.
    public let title: String

    /// The instance server's description.
    public let description: String

    /// The instance server's contact email address.
    public let email: String

    /// The instance server's software version.
    public let version: String

    /// The website URL to the instance server's thumbnail image.
    public let thumbnail: String?

    /// The instance server's URLs.
    public let urls: Field

    /// The instance server's statistics.
    public let stats: Field

    /// The instance server's supported languages.
    public let languages: [String]

    /// The instance server's contact account.
    public let contactAccount: Account

    private enum CodingKeys: String, CodingKey {
        case uri
        case title
        case description
        case email
        case version
        case thumbnail
        case urls
        case stats
        case languages
        case contactAccount = "contact_account"
    }
}
