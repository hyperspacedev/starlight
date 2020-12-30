//
//  Client.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/12/20.
//

import Foundation
import Combine
import KeychainSwift

/**
The primary client object that handles all fediverse requests.. It basically works as the logic controller of all the
networking done by the app.

Most of the getter and setter methods work asynchronously when calling the DispatchQueue and will usually not return
data. This model works best in scenarios where data needs to be loaded into a view.
 
- Version 1.1
 */
public class AppClient: CombineAPI, CustomStringConvertible {

    // MARK: PROPERTIES

    internal let session: URLSession

    /// The domain where the fediverse instance for the client lives.
    public let baseURL: String

    /// The user's access token to access the fediverse instance.
    public let token: String?

    /// The user's account id so that we can distinguish it from other users.
    public var userID: String?


    // MARK: CONSTRUCTORS

    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)

        let keychain = KeychainSwift()
        self.baseURL = keychain.get("baseURL") ?? "mastodon.social"
        self.token = keychain.get("token")
        self.userID = keychain.get("userID")
    }

    convenience init() {
        self.init(configuration: .default)
    }

    // MARK: GETTER METHODS

    /**
     Gets the stream of statuses for a specified timeline.
     - Parameter scope: The timeline scope to get.
     - Parameter maxID: The ID of the statuses whose older statuses we wish to obtain.
     - Parameter minID: The ID of the statuses whose older newer we wish to obtain.
     */
    func getPosts(scope: TimelineScope, maxID: String? = nil,
                  minID: String? = nil) -> AnyPublisher<[Status], Error> {

        /// The path to the API request
        var path: String

        /// The URL's query items (e.g. `local`, `maxID`, et al.)
        var queryItems = [URLQueryItem]()

        /// The request's headers, such as the user token, for example.
        var headers = [String: Any]()

        //  Here we check the timeline scope, so that we just retrieve the posts we want.
        switch scope {

        //  Here we obtain the user's timeline, and since the home timeline is user-specific, we are going to
        //  be required the user token.
        case .home:

            //  We will always need the token, so let's make sure that the token is not nil.
            //  If everything goes fine, this should always be true, because a login screen is supposed
            //  to be shown before loading the home page, but let's just ensure no weird things happen.
            assert(self.token != nil, "Retrieving the home timeline requires the user token.")

            headers = [
                "token": self.token! // Since we already made sure that the token was not nil above, we can now safely force-unwrap the value.
            ]

            path = "/timelines/home"

        case .direct:
            path = "/timelines/direct"

        case .account(let accountID):
            path = "/accounts/\(accountID)/statuses"
            print("Path is now \(path)")

        // If scope is either public or local, we just use the default clause.
        default:
            path = "/timelines/public"
            queryItems.append(
                URLQueryItem(
                    name: "local",
                    value: "\(scope == .local ? "true" : "false")" // Here we add whether we want the local or public statuses to the query items.
                )
            )
        }
        
        //  There is going to be times when we will only want to retrive statuses older than a specific id
        if let identifier = maxID {
            queryItems.append(
                URLQueryItem(
                    name: "maxID",
                    value: "\(identifier)"
                )
            )
        }

        //  There will also be times when we will only want to retrive statuses newer than a specific id
        if let identifier = minID {
            queryItems.append(
                URLQueryItem(
                    name: "minID",
                    value: "\(identifier)"
                )
            )
        }

        //  We declare the endpoint we are going to use, with all the elements specified above.
        let endpoint = Endpoint(self.baseURL, path, queryItems: queryItems, headers: headers)

        print("""
        ======== APPCLIENT ========
        Starting to fetch timeline...

        Endpoint:
        \(endpoint)

        Base url: \(endpoint.url)
        QueryItems: \(endpoint.queryItems)
        Headers: \(endpoint.headers)
        ===== END OF APPCLIENT =====
        """)

        return execute(endpoint.request, decodingType: [Status].self, retries: 2)

    }

    /**
     Get the user's notification stream.
     */
    public func getNotifications() -> AnyPublisher<[Notification], Error> {

        /// The path to the API request
        let path = "/notifications"

        //  We will always need the token, so let's make sure that the token is not nil.
        //  If everything goes fine, this should always be true, because a login screen is supposed
        //  to be shown before loading the home page, but let's just ensure no weird things happen.
        assert(self.token != nil, "Retrieving the notifications requires the user token.")

        /// The request's headers.
        let headers: [String: Any] = [
            "token": self.token! // Since we already made sure that the token was not nil above, we can now safely force-unwrap the value.
        ]

        //  We declare the endpoint we are going to use, with all the elements specified above.
        let endpoint = Endpoint(self.baseURL, path, headers: headers)

        print("""
        ======== APPCLIENT ========
        Starting to fetch the notifications...

        Endpoint:
        \(endpoint)

        Base url: \(endpoint.url)
        QueryItems: \(endpoint.queryItems)
        Headers: \(endpoint.headers)
        ===== END OF APPCLIENT =====
        """)

        return execute(endpoint.request, decodingType: [Notification].self, retries: 2)
    }

    /**
     Get the context for a given status.
     - Parameter forStatus: The status to get the contextual data for.
     */
    public func getContext(for statusID: String) -> AnyPublisher<Context, Error> {

        /// The path to the API request
        let path = "/statuses/\(statusID)/context"

        //  We declare the endpoint we are going to use, with all the elements specified above.
        let endpoint = Endpoint(self.baseURL, path)

        print("""
        ======== APPCLIENT ========
        Starting to fetch the context for the status with id: \(statusID)...

        Endpoint:
        \(endpoint)

        Base url: \(endpoint.url)
        QueryItems: \(endpoint.queryItems)
        Headers: \(endpoint.headers)
        ===== END OF APPCLIENT =====
        """)

        return execute(endpoint.request, decodingType: Context.self, retries: 2)
    }

    /**
     Get the account with a given ID.
     - Parameter withID: The ID number associated with the account.
     */
    public func getAccount(withID: String) -> AnyPublisher<Account, Error> {

        /// The path to the API request
        let path = "/accounts/\(withID)"

        //  We declare the endpoint we are going to use, with all the elements specified above.
        let endpoint = Endpoint(self.baseURL, path)

        print("""
        ======== APPCLIENT ========
        Starting to fetch the account with id: \(withID)...

        Endpoint:
        \(endpoint)

        Base url: \(endpoint.url)
        QueryItems: \(endpoint.queryItems)
        Headers: \(endpoint.headers)
        ===== END OF APPCLIENT =====
        """)

        return execute(endpoint.request, decodingType: Account.self, retries: 2)
    }

    /**
     Get the trending hashtags on a server.
     */
    public func getTrends() -> AnyPublisher<[Tag], Error> {

        /// The path to the API request
        let path = "/trends"

        //  We declare the endpoint we are going to use, with all the elements specified above.
        let endpoint = Endpoint(self.baseURL, path)

        print("""
        ======== APPCLIENT ========
        Starting to fetch the instances trending topics...

        Endpoint:
        \(endpoint)

        Base url: \(endpoint.url)
        QueryItems: \(endpoint.queryItems)
        Headers: \(endpoint.headers)
        ===== END OF APPCLIENT =====
        """)

        return execute(endpoint.request, decodingType: [Tag].self, retries: 2)

    }

}
