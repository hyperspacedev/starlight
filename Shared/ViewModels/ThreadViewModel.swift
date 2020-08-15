//
//  ThreadViewModel.swift
//  Codename Starlight
//
//  Created by Alejandro Modroño Vara on 12/07/2020.
//

import Foundation

/// An ``ObservableObject`` that computes and retrieves replies to a status on demand from the fediverse,
/// using Mastodon's API endpoints.
public class ThreadViewModel: ObservableObject {

    // MARK: - STORED PROPERTIES

    /// An array of several ``Status``es, that compose the status' thread.
    @Published var context: Context?

    // MARK: - FUNCTIONS

    /// View statuses above and below this status in the thread.
    ///
    /// - Parameters:
    ///     - id: The universal identifier of the status whose context we wish to obtain.
    func fetchContext(for statusId: String) {

        AppClient.shared().getContext(for: statusId, completion: { context in
            self.context = context
        })

    }

}
