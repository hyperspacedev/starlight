//
//  Client.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/12/20.
//

import Foundation

/// The primary client object that interfaces with fediverse APIs.
public class AppClient {

    // MARK: PROPERTIES

    /// The domain where the fediverse instance for the client lives.
    public let baseURL: URL

    /// The user's access token to access the fediverse instance.
    public let token: String

    // MARK: CONSTRUCTORS

    /**
     Initialize the AppClient object.
     - Parameter domain: The URL object that points to the fediverse instance.
     - Parameter token: The access token to use to authenticate with the server. Defaults to using `UserDefaults`.
     */
    init(domain: URL, token: String? = UserDefaults.standard.string(forKey: "accessToken")) {
        self.baseURL = domain
        self.token = token ?? ""
    }

    /**
     Initialize the AppClient object.
     - Parameter domain: A string representing the URL to the fediverse instance.
     - Parameter token: The access token to use to authenticate with the server. Defaults to using `UserDefaults`.
     */
    init(domain: String, token: String? = UserDefaults.standard.string(forKey: "accessToken")) {
        self.baseURL = URL(string: domain)!
        self.token = ""
    }

    // MARK: GETTER METHODS

    /**
     Gets the stream of statuses for a specified timeline.
     - Parameter scope: The timeline scope to get.
     - Returns: A list of statuses from the requested timeline.
     */
    public func getTimeline(scope: TimelineScope) -> [Status] {
        switch scope {
        case .public:
            return []
        default:
            return []
        }
    }

    /**
     Get the user's notification stream.
     - Returns: A list of notifications from the server.
     */
    public func getNotifications() -> [Notification] {
        return []
    }

    /**
     Get the context for a given status.
     - Parameter forStatus: The status to get the contextual data for.
     - Returns: A context object containing the ancestors and descendants for this status.
     */
    public func getContext(forStatus: Status) -> Context? {
        return getContext(forStatusID: forStatus.id)
    }

    /**
     Get the context for a given status from its ID.
     - Parameter forStatusID: The status ID to get the contextual data for.
     - Returns: A context object containing the ancestors and descendants for this status.
     */
    public func getContext(forStatusID: String) -> Context? {
        return nil
    }

    /**
     Get the account with a given ID.
     - Parameter withID: The ID number associated with the account.
     - Returns: The account object with the account ID.
     */
    public func getAccount(withID: String) -> Account? {
        return nil
    }

    /**
     Get the statuses associated with a given ID.
     - Parameter withID: The ID number associated with the account.
     - Returns: A list of statuses created by the account with the account ID.
     */
    public func getStatusesForAccount(withID: String) -> [Status] {
        return []
    }

    /**
     Get the statuses associated with an account.
     - Parameter account: The account object to gather statuses from.
     - Returns: A list of statuses created by the account.
     */
    public func getStatusesForAccount(_ account: Account) -> [Status] {
        return getStatusesForAccount(withID: account.id)
    }

}
