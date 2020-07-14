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

    // MARK: PRIVATE UTILITIES

    /**
     Create an authentication request to the server.
     - Parameter url: The URL to make a request to.
     - Parameter method: The request method.
     - Returns: `URLRequest` with the Authorization header from the user's access token.
     */
    private func makeAuthenticatedRequest(url: URL, method: String = "GET") -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        return request
    }

    /**
     Create an authentication request to the server.
     - Parameter url: The URL to make a request to.
     - Parameter method: The request method.
     - Returns: `URLRequest` with the Authorization header from the user's access token.
     */
    private func makeAuthenticatedRequest(url: String, method: String = "GET") -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        return request
    }

    // MARK: GETTER METHODS
    /// A shared version of the AppClient. Limits activity to `mastodon.social` and uses public endpoints.
    class func shared() -> AppClient {
        return defaultInstance
    }

    /**
     Gets the stream of statuses for a specified timeline.
     - Parameter scope: The timeline scope to get.
     - Parameter completion: A closure that utilizes the resulting statuses (`([Status]) -> Void`).
     */
    public func getTimeline(scope: TimelineScope, completion: @escaping ([Status]) -> Void) {
        var apiURL = baseURL

        switch scope {
        case .home:
            let request = makeAuthenticatedRequest(url: "/ap1/v1/timelines/home")
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                if (error) != nil {
                    print("Error: \(error as Any)")
                }
                DispatchQueue.main.async {
                    do {
                        let results = try JSONDecoder().decode([Status].self, from: data!)
                        completion(results)
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
            .resume()
            return
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
                    completion(results)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        .resume()
    }

    /**
     Get the user's notification stream.
     - Parameter completion: A closure utilizing the notification data `([Notification]) -> Void`.
     */
    public func getNotifications(completion: @escaping([Notification]) -> Void) {
        let request = makeAuthenticatedRequest(url: "/api/v1/notifications")
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if error != nil {
                print("Error: \(error as Any)")
            }
            DispatchQueue.main.async {
                do {
                    let results = try JSONDecoder().decode([Notification].self, from: data!)
                    completion(results)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        .resume()
    }

    /**
     Get the context for a given status.
     - Parameter forStatus: The status to get the contextual data for.
     - Parameter completion: A closure that utilizes the context data (`(Context) -> Void`).
     */
    public func getContext(forStatus: Status, completion: @escaping (Context) -> Void) {
        getContext(forStatusID: forStatus.id, completion: completion)
    }

    /**
     Get the context for a given status from its ID.
     - Parameter forStatusID: The status ID to get the contextual data for.
     - Parameter completion: A closure that utilizes the context data (`(Context) -> Void`).
     */
    public func getContext(forStatusID: String, completion: @escaping (Context) -> Void) {
        let apiRequest = baseURL.appendingPathComponent("/api/v1/statuses/\(forStatusID)/context")
        URLSession.shared.dataTask(with: apiRequest) { data, _, error in
            if error != nil {
                print("Error: \(error as Any)")
            }
            DispatchQueue.main.async {
                do {
                    let context = try JSONDecoder().decode(Context.self, from: data!)
                    completion(context)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        .resume()
    }

    /**
     Get the account with a given ID.
     - Parameter withID: The ID number associated with the account.
     - Parameter completion: A closure that utilizes the resulting account data (`(Account) -> Void`).
     */
    public func getAccount(withID: String, completion: @escaping (Account) -> Void) {
        var apiURL = baseURL
        apiURL.appendPathComponent("/api/v1/accounts/\(withID)")
        URLSession.shared.dataTask(with: apiURL) { data, _, error in
            if error != nil {
                print("Error: \(error as Any)")
            }
            DispatchQueue.main.async {
                do {
                    let accountData = try JSONDecoder().decode(Account.self, from: data!)
                    completion(accountData)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        .resume()
    }

    /**
     Get the statuses associated with a given ID.
     - Parameter withID: The ID number associated with the account.
     - Parameter completion: A closure that utilizes the resulting data (`([Status]) -> Void`).
     */
    public func getStatusesForAccount(withID: String, completion: @escaping ([Status]) -> Void) {
        var apiURL = baseURL
        apiURL.appendPathComponent("/api/v1/accounts/\(withID)/statuses")
        URLSession.shared.dataTask(with: apiURL) { data, _, error in
            if error != nil {
                print("Error: \(error as Any)")
            }
            DispatchQueue.main.async {
                do {
                    let results = try JSONDecoder().decode([Status].self, from: data!)
                    completion(results)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        .resume()
    }

    /**
     Get the statuses associated with an account.
     - Parameter account: The account object to gather statuses from.
     - Parameter completion: A closure that utilizes the resulting data (`([Status]) -> Void`).
     */
    public func getStatusesForAccount(_ account: Account, completion: @escaping ([Status]) -> Void) {
        getStatusesForAccount(withID: account.id, completion: completion)
    }

}
