//
//  ExploreViewModel.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/14/20.
//

import Foundation
import Combine

/// An ``ObservableObject`` that computes and retrieves an instance's trending topicson demand,
/// using Mastodon's API endpoints.
public class ExploreViewModel: StateRepresentable {

    // An AnyCancellable property for networking purposes.
    private var cancellable: AnyCancellable?

    /// The app's client
    let client = AppClient()

    /// An array of several ``Tag``s, that compose the treding topics.
    @Published var tags = [Tag]()

    /// View statuses above and below this status in the thread.
    func fetchTags() {

        self.state = .loading(message: "Loading tags...")

        cancellable = client.getTrends()
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
                // Here the actual subscriber is created. As mentioned earlier, the sink-subscriber comes with a closure, that lets us handle the received value when it’s ready from the publisher.
            },
            receiveValue: { tags in
                print("""
                ======== POSTVIEWMODEL ========
                State before:
                \(self.state)

                """)

                self.state = .success(icon: "checkmark.circle.fill")
                self.tags = tags

                print("""
                State now:
                \(self.state)
                ==== END OF POSTVIEWMODEL ====
                """)
            })

    }

    //  MARK: - CONSTRUCTORS
    override init() {
        super.init()

        self.fetchTags()
    }

}
