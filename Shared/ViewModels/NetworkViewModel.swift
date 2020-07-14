//
//  NetworkViewModel:.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 11/07/2020.
//

import Foundation

/// An ``ObservableObject`` that computes and retrieves statuses on demand from the fediverse,
/// using Mastodon's API endpoints.
public class NetworkViewModel: ObservableObject {

    // MARK: - STORED PROPERTIES

    /// An array composed of several ``Status``, that compose the timeline.
    @Published var statuses = [Status]()

    @Published var type: TimelineScope = .local {
        didSet {
            AppClient.shared().getTimeline(scope: self.type) { statuses in
                self.statuses = statuses
            }
        }
    }

    func fetchPublicTimeline() {
        AppClient.shared().getTimeline(scope: .public) { statuses in
            self.statuses = statuses
        }
    }

    func fetchLocalTimeline() {
        AppClient.shared().getTimeline(scope: .local) { statuses in
            self.statuses = statuses
        }
    }
}
