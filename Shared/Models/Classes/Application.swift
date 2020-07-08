//
//  Application.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/7/20.
//

import Foundation

/**
 A class representation of an application.
 
 An application is a registered service or app with the instance the user interacts with.
 */
public class Application: Codable, Identifiable {

    // MARK: - STORED PROPERTIES

    /// The ID for this application.
    // swiftlint:disable:next identifier_name
    public let id = UUID()

    /// The name of the application.
    public let name: String

    /// The application's website, if applicable.
    public let website: String?

    /// The application's API key for push streaming, if applicable.
    public let vapidKey: String?

    // MARK: - COMPUTED PROPERTIES

    private enum CodingKeys: String, CodingKey {
        case name
        case website
        case vapidKey = "vapid_key"
    }
}

/// Grants us conformance to `Hashable` for _free_
extension Application: Hashable {
    public static func == (lhs: Application, rhs: Application) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
