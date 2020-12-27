//
//  ThreadViewModel.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 12/07/2020.
//

import Foundation
import Combine

/// An ``ObservableObject`` that computes and retrieves replies to a status on demand from the fediverse,
/// using Mastodon's API endpoints.
public class ContextViewModel: StateRepresentable {

    // MARK: - STORED PROPERTIES

    // An AnyCancellable property for networking purposes.
    private var cancellable: AnyCancellable?

    /// The app's client
    let client = AppClient()

    /// An array of several ``Status``es, that compose the status' thread.
    @Published var context: Context?

    // MARK: - FUNCTIONS

    /// View statuses above and below this status in the thread.
    ///
    /// - Parameters:
    ///     - id: The universal identifier of the status whose context we wish to obtain.
    func fetch(for statusID: String) {

        self.state = .loading(message: "Loading context...")

        cancellable = client.getContext(for: statusID)
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
            receiveValue: { context in
                print("""
                ======== POSTVIEWMODEL ========
                State before:
                \(self.state)

                """)

                self.state = .success(icon: "checkmark.circle.fill")
                self.context = context

                print("""
                State now:
                \(self.state)
                ==== END OF POSTVIEWMODEL ====
                """)
            })

    }

}
