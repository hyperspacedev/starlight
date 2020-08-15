//
//  ProfileViewModel.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/14/20.
//

import Foundation
import SwiftUI

public class ProfileViewModel: ObservableObject {

    // MARK: STORED PROPERTIES

    @Published var statuses = [Status]()

    @Published var data: Account?

    @Published var accountID: String = "0" {
        didSet {
            AppClient.shared().getAccount(withID: accountID) { acctData in
                self.data = acctData
            }
        }
    }

    init(accountID: String) {
        self.accountID = accountID
    }

    // swiftlint:disable:next large_tuple
    var badge: (label: String, labelColor: Color, backgroundColor: Color)? {

        let devs = [
            "329742",   // amodrono@mastodon.technology
            "367895"    // alicerunsonfedora
        ]

        let testAccts = [
            "724754" // Starlight Alpha
        ]

        if let identifier = self.data?.id {

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

    public func fetchProfileStatuses() {
        AppClient.shared().getStatusesForAccount(withID: accountID) { statuses in
            self.statuses = statuses
//            scrollview.scrollTo(self.statuses[0])
        }
    }

    public func fetchProfile() {
        AppClient.shared().getAccount(withID: accountID) { account in
            self.data = account
        }
    }

    func updateProfileStatuses(currentItem: Status) {

        if !shouldLoadMoreData(currentItem: currentItem) {
            return
        }

        AppClient.shared().getStatusesForAccount(
            withID: accountID, maxID: self.statuses[self.statuses.count - 1].id) { statuses in
            self.statuses.append(contentsOf: statuses)
        }

    }

    func refreshProfileStatuses() {

        AppClient.shared().getStatusesForAccount(withID: accountID, minID: self.statuses[0].id) { statuses in
            self.statuses.insert(contentsOf: statuses, at: self.statuses.startIndex)
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
