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

    /// An array composed of several ``Status``, that compose the status' thread.
    @Published var thread = [Status]()

    // MARK: - FUNCTIONS

    /// View statuses above and below this status in the thread.
    ///
    /// - Parameters:
    ///     - id: The universal identifier of the status whose thread we wish to obtain.
    func fetchReplies(from: String) {

        guard let url = URL(string: "https://mastodon.social/api/v1/statuses/\(from)/context") else { return }

        URLSession.shared.dataTask(with: url) { (data, resp, error) in

            print("resp: \(resp as Any)\n\nerror: \(String(describing: error))\n\ndata: \(String(describing: data))")

            DispatchQueue.main.async {
                do {
                        let result = try JSONDecoder().decode([Status].self, from: data!)
                        self.thread = result
                        print("result: \(result)")
                } catch {
                    print(error)
                }
            }

        }
        .resume()

    }

}
