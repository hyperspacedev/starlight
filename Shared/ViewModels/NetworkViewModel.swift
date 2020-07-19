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
            self.fetchTimeline()
        }
    }

    subscript(position: Int) -> Status {
        return statuses[position]
    }

    func fetchTimeline() {
        AppClient.shared().getTimeline(scope: self.type) { statuses in
            self.statuses = statuses
        }
    }

    func updateTimeline(currentItem: Status) {

        if !shouldLoadMoreData(currentItem: currentItem) {
            return
        }

        AppClient.shared().updateTimeline(action: .loadPage, scope: self.type, id: currentItem.id) { statuses in
            self.statuses.append(contentsOf: statuses)
        }

    }

    /// Whether more data should be loaded.
    ///
    /// This is required for infinite scrolling to work.
    /// What it does is check whether the status loaded is the fourth last status
    /// (in this case the 16th), and if it's the case, it will load more data,
    /// so that there's an infinite list of statuses.
    func shouldLoadMoreData(currentItem: Status? = nil) -> Bool {
        guard let currentItem = currentItem else {
            return true
        }

        for index in ( self.statuses.count - 4)...(self.statuses.count - 1) {
            if index >= 0 && currentItem.id == self.statuses[index].id {
                return true
            }
        }
        return false
    }

}
