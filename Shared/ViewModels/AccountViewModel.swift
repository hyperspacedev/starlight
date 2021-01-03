//
//  AccountViewModel.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/14/20.
//

import Foundation
import SwiftUI
import Combine

public class AccountViewModel: StateRepresentable {

    // MARK: STORED PROPERTIES

    /// An AnyCancellable property for networking purposes.
    private var cancellable: AnyCancellable?

    /// The app's client
    let client = AppClient()

    /// The account data structure
    @Published var account: Account?

    /// The account's timeline
    @ObservedObject var timeline: TimelineViewModel

    // swiftlint:disable:next large_tuple
    var badge: (label: String, labelColor: Color, backgroundColor: Color)? {

        let devs = [
            "329742",   // amodrono@mastodon.technology
            "367895"    // alicerunsonfedora
        ]

        let testAccts = [
            "724754" // Starlight Alpha
        ]

        if let identifier = self.account?.id {

            if devs.contains(identifier) {
                #if os(iOS)
                return (label: "DEV", labelColor: .secondary, backgroundColor: Color(.systemGray5))
                #else
                return (label: "DEV", labelColor: .secondary, backgroundColor: .gray)
                #endif
            }

            if testAccts.contains(identifier) {
                return (label: "TEST ACCOUNT", labelColor: .white, backgroundColor: .secondary)
            }

            if identifier == "1" {
                return (label: "MASTODON DEV", labelColor: .white, backgroundColor: .purple)
            }

        }

        return nil

    }

    /// Fetch the account with the specified id
    ///
    /// - Parameters:
    ///     - id: The universal identifier of the account we wish to obtain.
    func fetch(for accountID: String) {

        self.state = .loading(message: "Loading account...")

        //  First, we fetch the account.
        cancellable = client.getAccount(withID: accountID)
            .sink(receiveCompletion: { completion in

                switch completion {
                case .failure:

                    if isConnectedToNetwork() {
                        self.state = .error(
                            message: "There is no internet connection available, please try again later...",
                            icon: "wifi.slash"
                        )
                    } else {

                        self.state = .error(message: "Something went wrong, try again later...", icon: "xmark.fill")

                    }

                case .finished: break
                }
                //  Here the actual subscriber is created. As mentioned earlier,
                //  the sink-subscriber comes with a closure, that lets us handle
                //  the received value when it’s ready from the publisher.
            },
            receiveValue: { account in
                print("""
                ======== POSTVIEWMODEL ========
                State before:
                \(self.state)

                """)

                self.state = .success(icon: "checkmark.circle.fill")
                self.account = account

                print("""
                State now:
                \(self.state)
                ==== END OF POSTVIEWMODEL ====
                """)
            })

    }

    // MARK: - CONSTRUCTORS
    public init(accountID: String) {

        //  We fetch the account's statuses as if it were a timeline
        //  Now, if we want to access the account's data we would simply do: viewModel.timeline.statuses
        self.timeline = TimelineViewModel(scope: .account(identifier: accountID))

        //  This way we can now interact with the account's timeline easily, and we don't need to implement all the
        //  functions such as `fetchAccountStatuses`, because we will already be using the ones implemented
        //  in TimelineViewModel, so our code is cleaner, and easier to maintain.

        //  A designated initializer must ensure that all of the “properties introduced by its class are
        //  initialized before it delegates up to a superclass initializer, so once we've initialized the
        //  timeline, we can now call the original class' init function.
        //
        //  Reference: https://stackoverflow.com/a/24021346
        super.init()

        //  Once we've done all that, we fetch the account.
        self.fetch(for: accountID)

    }

}
