//
//  TimelineViewableScope.swift
//  Starlight
//
//  Created by Marquis Kurt on 2/10/21.
//

import Foundation

/// An enumeration that represents the different possibilities for a timeline of posts.
enum TimelineViewableScope {
    case home
    case messages
    case empty
    case network(localOnly: Bool)
    case list(id: String)
    case tag(id: String)
    case profile(id: String)
}
