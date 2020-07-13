//
//  Client.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/12/20.
//

import Foundation

public class AppClient {

    public let baseURL: URL
    public let token: String?

    // TODO: Complete this function.
    /// Gets the stream of statuses for a specified timeline.
    public func getTimeline(scope: TimelineScope) -> [Status] {
        switch scope {
        case .public:
            return []
        default:
            return []
        }
    }

    // TODO: Complete this function.
    public func getNotifications() -> [Notification] {
        return []
    }

    init(fromUrl: String) {
        self.baseURL = URL(string: fromUrl)!
        self.token = ""
    }

    init(fromUrl: URL) {
        self.baseURL = fromUrl
        self.token = ""
    }
}
