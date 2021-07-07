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

    public struct AccountStruct {

        /// The user's access token to access the fediverse instance.
        public var token: String?

        /// The user's account id so that we can distinguish it from other users.
        public var userID: String?

    }

    public struct ClientSecrets {

        /// The client's identifier.
        public var clientId: String

        /// Client secret key, to be used for obtaining OAuth tokens
        public var clientSecret: String

    }

    internal let session: URLSession

    /// The URL of the instance where both the application and the user's account live.
    public static var baseURL: String?
    public static var account: AccountStruct?
    public static var secrets: ClientSecrets?

    // MARK: – CONSTRUCTORS

    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)

        let keychain = KeychainSwift()

        // User is logged in
        if let token = keychain.get("token") {

            //  We ensure the app was created successfully and that
            //  the user id was stored.
            guard keychain.get("userID") != nil else { return }
            guard keychain.get("clientID") != nil else { return }
            guard keychain.get("clientSecret") != nil else { return }
            
            AppClient.baseURL? = keychain.get("baseURL")!
            AppClient.account?.token = token
            AppClient.account?.userID = keychain.get("userID")!

            AppClient.secrets?.clientId = keychain.get("clientID")!
            AppClient.secrets?.clientSecret = keychain.get("clientSecret")!
        }

        return

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
    // swiftlint:disable:next function_body_length
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
            assert(AppClient.account?.token != nil, "Retrieving the home timeline requires the user token.")

            headers = [
                "token": AppClient.account?.token!
                //  Since we already made sure that the token was not nil above, we can now
                //  safely force-unwrap the value.
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
                    value: "\(scope == .local ? "true" : "false")"
                    // Here we add whether we want the local or public statuses to the query items.
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
        let endpoint = Endpoint(AppClient.baseURL!, path, queryItems: queryItems, headers: headers)

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
        assert(AppClient.account?.token != nil, "Retrieving the notifications requires the user token.")

        /// The request's headers.
        let headers: [String: Any] = [
            "token": AppClient.account?.token!
            //  Since we already made sure that the token was not nil above,
            //  we can now safely force-unwrap the value.
        ]

        //  We declare the endpoint we are going to use, with all the elements specified above.
        let endpoint = Endpoint(AppClient.baseURL!, path, headers: headers)

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
        let endpoint = Endpoint(AppClient.baseURL!, path)

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
        let endpoint = Endpoint(AppClient.baseURL!, path)

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
        let endpoint = Endpoint(AppClient.baseURL!, path)

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

    // MARK: – LOG IN

    /**
     *  Login and get the access token of an account.
     */
    public func logIn(baseURL: String) -> AnyPublisher<Account, Error> {
        
        AppClient.baseURL = baseURL

        //  We first create our app.
        self.createApp()
            .sink(receiveCompletion: { _ in
                //  Here the actual subscriber is created. As mentioned earlier,
                //  the sink-subscriber comes with a closure, that lets us handle
                //  the received value when it’s ready from the publisher.
            },
            receiveValue: { app in
                AppClient.secrets?.clientId = app.clientId!
                AppClient.secrets?.clientSecret = app.clientSecret!
            })

        //  We then ensure it works
        self.verifyAppWorks()
            .sink(receiveCompletion: { _ in
                //  Here the actual subscriber is created. As mentioned earlier,
                //  the sink-subscriber comes with a closure, that lets us handle
                //  the received value when it’s ready from the publisher.
            },
            receiveValue: { app in
                assert(app.clientId != AppClient.secrets?.clientId, "Application failed registering.")
            })

        //  We now create the account

        /// The path to the API request
        let path = "/authorize"

        /// The URL's query items (e.g. `local`, `maxID`, et al.)
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: AppClient.secrets?.clientId),
            URLQueryItem(name: "redirect_uri", value: "urn:ietf:wg:oauth:2.0:oob")
        ]

        //  We declare the endpoint we are going to use, with all the elements specified above.
        //  In this case, we are working with Mastodon's OAuth, so we need to tell that to our endpoints.
        let endpoint = Endpoint(api: "/oauth", AppClient.baseURL!, path)

        print("""
        ======== APPCLIENT ========
        Starting to authorize the account...

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
     *  Create an application in the specified instance that will be used for
     *  interacting with the fediverse.
     */
    public func createApp() -> AnyPublisher<Application, Error> {
        
        /// The path to the API request
        let path = "/apps"
        
        /// The app's client name
        #if os(iOS)
        let clientName: String = "Starlight (iOS & iPadOS)"
        #else
        let clientName: String = "Starlight (macOS)"
        #endif

        /// The URL's query items (e.g. `local`, `maxID`, et al.)
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "client_name", value: clientName),
            URLQueryItem(name: "redirect_uris", value: "urn:ietf:wg:oauth:2.0:oob"),
            URLQueryItem(name: "scopes", value: "read write"),
            URLQueryItem(name: "website", value: "https://hyperspace.marquiskurt.com")
        ]

        //  We declare the endpoint we are going to use, with all the elements specified above.
        let endpoint = Endpoint(AppClient.baseURL!, path, queryItems: queryItems)

        print("""
        ======== APPCLIENT ========
        Starting to create the application in the chosen instance...

        Endpoint:
        \(endpoint)

        Base url: \(endpoint.url)
        QueryItems: \(endpoint.queryItems)
        Headers: \(endpoint.headers)
        ===== END OF APPCLIENT =====
        """)

        return execute(endpoint.request, decodingType: Application.self, retries: 2)

    }

    /**
     *  Create an application in the specified instance that will be used for
     *  interacting with the fediverse.
     */
    public func verifyAppWorks() -> AnyPublisher<Application, Error> {
        
        /// The path to the API request
        let path = "/apps/verify_credentials"
        
        /// The app's client name
        #if os(iOS)
        let clientName: String = "Starlight (iOS & iPadOS)"
        #else
        let clientName: String = "Starlight (macOS)"
        #endif

        /// The request's headers, such as the user token, for example.
        var headers: [String: Any] = [
            "token": AppClient.secrets?.clientSecret
            //  Since we already made sure that the token was not nil above, we can now
            //  safely force-unwrap the value.
        ]

        //  We declare the endpoint we are going to use, with all the elements specified above.
        let endpoint = Endpoint(AppClient.baseURL!, path, headers: headers)

        print("""
        ======== APPCLIENT ========
        Starting to create the application in the chosen instance...

        Endpoint:
        \(endpoint)

        Base url: \(endpoint.url)
        QueryItems: \(endpoint.queryItems)
        Headers: \(endpoint.headers)
        ===== END OF APPCLIENT =====
        """)

        return execute(endpoint.request, decodingType: Application.self, retries: 2)

    }


    // MARK: – PROPERTIES
    public static var isLoggedIn: Bool {

        //  Logically, if we are logged in, the account token shouldn't be nil.
        return AppClient.account?.token != nil

    }

}
