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

//    var isDev: Bool {
//        let devs = [
//            ["alicerunsonfedora", "mastodon.social"],
//            ["amodrono", "mastodon.social"],
//            ["Gargron", "mastodon.social"]
//        ]
//
//        if let username = self.data?.acct {
//            for item in devs {
//                if AppClient.shared().baseURL == URL(string: "mastodon.social") {
//                    if item.contains(username) {
//                        return true
//                    }
//                    return false
//                } else {
//                    if username == "\(item[0])@\(item[1])" {
//                        return true
//                    }
//                    return false
//                }
//            }
//        }
//
//        return false
//    }

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

        AppClient.shared().getStatusesForAccount(withID: accountID, maxID: currentItem.id) { statuses in
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
