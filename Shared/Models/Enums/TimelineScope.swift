//
//  TimelineScope.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/12/20.
//

import Foundation

public enum TimelineScope {
    case home
    case local
    case `public`
    case direct
    case account(id: String)
}
