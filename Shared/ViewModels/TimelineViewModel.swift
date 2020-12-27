//
//  TimelineViewModel.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 11/07/2020.
//

import Foundation
import Combine

/// An ``ObservableObject`` that computes and retrieves statuses on demand from the fediverse,
/// using Mastodon's API endpoints.
public class TimelineViewModel: StateRepresentable {

    // MARK: - STORED PROPERTIES

    /// An AnyCancellable property for networking purposes.
    private var cancellable: AnyCancellable?

    /// The app's client
    let client = AppClient()

    /// An array composed of several ``Status``, that compose the timeline.
    @Published var statuses = [Status]()

    @Published var type: TimelineScope = .local {
        didSet {
            self.load() // We want to retrieve the posts each time we change timelines.
        }
    }

    subscript(position: Int) -> Status {
        return statuses[position]
    }

    func fetch(minID: String? = nil, maxID: String? = nil, completion: @escaping ([Status]) -> Void) {

        cancellable = client.getPosts(scope: self.type, maxID: maxID, minID: minID)
            .sink(receiveCompletion: { completion in

                switch completion {
                case .failure:

                    if isConnectedToNetwork() {
                        self.state = .error(message: "There is no internet connection available, please try again later...", icon: "wifi.slash")
                    } else {

                        self.state = .error(message: "Something went wrong, try again later...", icon: "xmark.fill")

                    }

                case .finished: break
                }
                // Here the actual subscriber is created. The sink-subscriber comes with a closure, that lets us handle the received value when it’s ready from the publisher.
            },
            receiveValue: { statuses in
                print("""
                ======== POSTVIEWMODEL ========
                State before:
                \(self.state)

                """)

                self.state = .success(icon: "checkmark.circle.fill")
                completion(statuses)

                print("""
                State now:
                \(self.state)
                ==== END OF POSTVIEWMODEL ====
                """)
            })
    }

    /// Retrieves the timeline's contents
    func load() {

        self.state = .loading(message: "Loading timeline...")

        self.fetch() {
            self.statuses = $0
        }
    }

    /// Adds new content to the timeline retrieved.
    ///
    /// - Parameter from: The last status loaded, so that we are sure we are only loading newer statuses.
    ///
    func refreshTimeline(from statusID: String) {

        self.state = .loading(message: "Refreshing timeline...")

        self.fetch(minID: statusID) {
            self.statuses.insert(contentsOf: $0, at: self.statuses.startIndex)
        }
    }

    func updateTimeline(from statusID: String) {

        if !shouldLoadMoreData(currentItem: statusID) {
            return
        }

        self.fetch(maxID: statusID) {
            self.statuses.append(contentsOf: $0)
        }

    }

    /// Whether more data should be loaded.
    ///
    /// This is required for infinite scrolling to work.
    /// What it does is check whether the status loaded is the second to last status,
    /// and if it's the case, it will load more data, so that there's an
    /// infinite list of statuses.
    func shouldLoadMoreData(currentItem: String) -> Bool {

        if currentItem == self.statuses[self.statuses.count - 2].id {
            return true
        }
        return false

    }

    // MARK: - CONSTRUCTORS
    override init() {
        super.init()

        self.load()
    }

}
