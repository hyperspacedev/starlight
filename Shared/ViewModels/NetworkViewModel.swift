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

    func refreshTimeline(from currentItem: Status) {

        AppClient.shared().getTimeline(scope: self.type, minID: currentItem.id) { statuses in
            self.statuses.insert(contentsOf: statuses, at: self.statuses.startIndex)
        }

    }

    func updateTimeline(currentItem: Status) {

        if !shouldLoadMoreData(currentItem: currentItem) {
            return
        }

        AppClient.shared().getTimeline(scope: self.type, maxID: currentItem.id) { statuses in
            self.statuses.append(contentsOf: statuses)
        }

    }

    /// Whether more data should be loaded.
    ///
    /// This is required for infinite scrolling to work.
    /// What it does is check whether the status loaded is the second last status,
    /// and if it's the case, it will load more data, so that there's an
    /// infinite list of statuses.
    func shouldLoadMoreData(currentItem: Status) -> Bool {

        if currentItem.id == self.statuses[self.statuses.count - 2].id {
            return true
        }
        return false

    }

}
