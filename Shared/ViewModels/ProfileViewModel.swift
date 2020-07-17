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

    init(accountID: String) {
        self.accountID = accountID
    }
}
