//
//  LoginViewModel.swift
//  Hyperspace
//
//  Created by Alex Modroño Vara on 7/3/21.
//

import Foundation
import SwiftUI
import Combine

public class LoginViewModel: StateRepresentable {

    // MARK: STORED PROPERTIES

    /// An AnyCancellable property for networking purposes.
    private var cancellable: AnyCancellable?

    /// The app's client
    let client = AppClient()

    /// The account data structure
    @Published var account: Account?

    /// Fetch the account with the specified id
    ///
    /// - Parameters:
    ///     - id: The universal identifier of the account we wish to obtain.
    func logIn(for accountID: String) {

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

}
