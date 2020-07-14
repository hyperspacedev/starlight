//
//  ProfileViewModel.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/14/20.
//

import Foundation

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

    public func fetchProfileStatuses() {
        AppClient.shared().getStatusesForAccount(withID: accountID) { statuses in
            self.statuses = statuses
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
