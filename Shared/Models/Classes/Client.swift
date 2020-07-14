//
//  Client.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/12/20.
//

import Foundation

/**
 The primary client object that handles all fediverse requests.
 
 Most of the getter and setter methods works asynchronously when calling the DispatchQueue and will usually not return
 data. This model works best in scenarios where data needs to be loaded into a view.
 */
public class AppClient {

    // MARK: PROPERTIES

    /// The domain where the fediverse instance for the client lives.
    public let baseURL: URL

    /// The user's access token to access the fediverse instance.
    public let token: String

    /// A singleton version of the client. Limited to `mastodon.social` and public use.
    private static var defaultInstance: AppClient = {
        let client = AppClient(domain: "https://mastodon.social")
        return client
    }()

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
    /// A shared version of the AppClient. Limits activity to `mastodon.social` and uses public endpoints.
    class func shared() -> AppClient {
        return defaultInstance
    }

    /**
     Gets the stream of statuses for a specified timeline.
     - Parameter scope: The timeline scope to get.
     - Parameter after: A closure that utilizes the resulting statuses (`([Status]) -> Void`).
     */
    public func getTimeline(scope: TimelineScope, after: @escaping ([Status]) -> Void) {
        var apiURL = baseURL

        switch scope {
        case .public:
            apiURL.appendPathComponent("/api/v1/timelines/public")
        case .local:
            let originalURL = apiURL.absoluteString
            var localURL = URLComponents(string: originalURL)
            localURL?.path = "/api/v1/timelines/public"
            localURL?.queryItems = [
                URLQueryItem(name: "local", value: "true")
            ]
            apiURL = (localURL?.url)!
        default:
            break
        }

        URLSession.shared.dataTask(with: apiURL) { (data, _, error) in
            if (error) != nil {
                print("Error: \(error as Any)")
            }
            DispatchQueue.main.async {
                do {
                    let results = try JSONDecoder().decode([Status].self, from: data!)
                    after(results)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        .resume()
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
     - Parameter after: A closure that utilizes the resulting account data (`(Account) -> Void`).
     */
    public func getAccount(withID: String, after: @escaping (Account) -> Void) {
        var apiURL = baseURL
        apiURL.appendPathComponent("/api/v1/accounts/\(withID)")
        URLSession.shared.dataTask(with: apiURL) { data, _, error in
            if error != nil {
                print("Error: \(error as Any)")
            }
            DispatchQueue.main.async {
                do {
                    let accountData = try JSONDecoder().decode(Account.self, from: data!)
                    after(accountData)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }

    /**
     Get the statuses associated with a given ID.
     - Parameter withID: The ID number associated with the account.
     - Parameter after: A closure that utilizes the resulting data (`([Status]) -> Void`).
     */
    public func getStatusesForAccount(withID: String, after: @escaping ([Status]) -> Void) {
        var apiURL = baseURL
        apiURL.appendPathComponent("/api/v1/accounts/\(withID)/statuses")
        URLSession.shared.dataTask(with: apiURL) { data, _, error in
            if error != nil {
                print("Error: \(error as Any)")
            }
            DispatchQueue.main.async {
                do {
                    let results = try JSONDecoder().decode([Status].self, from: data!)
                    after(results)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }

    /**
     Get the statuses associated with an account.
     - Parameter account: The account object to gather statuses from.
     - Parameter after: A closure that utilizes the resulting data (`([Status]) -> Void`).
     */
    public func getStatusesForAccount(_ account: Account, after: @escaping ([Status]) -> Void) {
        return getStatusesForAccount(withID: account.id, after: after)
    }

}
