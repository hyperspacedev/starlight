//
//  DeeplinkResolver.swift
//  DeeplinkResolver
//
//  Created by Alejandro Modroño Vara on 30/10/21.
//

import SwiftUI

//  Deep linking in Starlight works in three parts:
//
//  1. First, the `starlight://` URL-scheme is called, followed by a specific set
//     of query items. These query items are sent to `Chica.handleURL()`, that,
//     based on the data it receives, will decide which action to perform.
//
//     Most of the cases, it will do a request to the required instance, receiving
//     in return some data in JSON.
//
//  2. Once the data is received from the server, it will decode the data to the
//     appropiate decodable data model, and will return a SwiftUI `View`, with this
//     data model as one of its parameters.
//
//  3. A state variable is assigned this new value. This will, in turn, trigger a
//     NavigationLink, which will finally show this view, that will be fed with the
//     retrieved data.
//
//  It is also good to know that Starlight can accept two types of parameters through
//  its URL-scheme:
//
//                                                             mastodon url (e.g.
//                                              ┌─────▶ https://social.mastodon.com/...)
//                                              │
//        URL (starting with starlight://) ─────┤
//                                              │        app-specific query items (e.g.
//                                              └─────▶           profileId=1)
//
//  Though only the latter will be used, because mastodon urls can't be interpreted by the app.
//  Because of this, we need to have a specific step, where the mastodon url is converted by
//  `DeeplinkResolver` to plain query items, which are now usable.
//
//                                                                                      DeeplinkResolver.convertToQueryParameters(_:)
//                                                             mastodon url (e.g.       ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐
//                                              ┌─────▶ https://social.mastodon.com/...) ──┐
//                                              │                                       │  │ Extracts the                           │
//        URL (starting with starlight://) ─────┤                                          │     query
//                                              │        app-specific query items (e.g. │  │  parameters                            │
//                                              └─────▶           profileId=1)           ◀─┘
//                                                                                      └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘
//
//  This allows us to pass entire mastodon urls through the url scheme, and still have deep
//  linking work correctly.
//
//  Below there's a diagram that explains all these steps in a more visual and summarized way.
//
//                             Starlight                                                    Chica
//                            ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─                       ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
//                                                                   │                                                       │
//                            │                                                             │
//                                                                   │                                                       │
//                            │ ┌─────────────────────────────────┐      Resolve whether    │  ┌───────────────────────────┐
//                              │                                 │  │  the link is valid      │                           │ │                                        Instance
//                            │ │     URL scheme is detected      │─────────────────────────┼─▶│      Chica.handleURL      │                                          ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐
//                              │                                 │  │                         │                           │ │                                       │
//                            │ └─────────────────────────────────┘                         │  └───────────────────────────┘                                                                          │
//                                               │                   │                                       │               │       ┌─────────────────────┐         │
//                            │                                                             │                ▼                       │                     │                                          │
//                                               │                   │                                                       ├──────▶│                     ├────────▶│
//                            │                                                             │    Detect which type of data           │ Request information │                                          │
//                                               │                   │                           the link refers to (is it   │◀──────┤  from the instance  │◀────────┤◀ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐
//                            │                                                             │      a status, an account,             │                     │                                          │
//                                               ▼                   │                                     etc.)             │       │                     │         │        │               │
//                            │                 ...                                         │                                        └─────────────────────┘                                          │
//                                                                   │                                       │               │                                       │        │               │
//                            │                  │                                          │                                                                                   Respond with          │
//                                                                   │                                       ▼               │                                       │        │  the correct  │
//                            │                  ▼                                          │  ┌───────────────────────────┐                                                    data in JSON          │
//                                 ┌───────────────────────────┐     │   Pass the decoded      │  Retrieve the id of the   │ │                                       │        │               │
//                            │    │                           │         data as argument   │  │  request and obtain real  │                                                         OR               │
//                                 │     DeeplinkResolver      │◀────┼─────────────────────────│data models that are usable│ │                                       │        │               │
//                            │    │                           │                            │  │        by the app.        │                                                      Return an           │
//                                 └───────────────────────────┘     │                         └───────────────────────────┘ │                                       │        │apropiate error│
//                            │                  │                                          │                                                                                       code              │
//                                                                   │                       ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘                                       │        │               │
//                            │                  ▼                                                                                                                                                    │  Other sources
//                                                                   │                                                                                               │        │               │─ ─ ─ ─ ◀─────────────────
//                            │         Resolve the correct                                                                                                                                           │
//                                          destination              │                                                                                               │        └ ─ ─ ─ ─ ─ ─ ─ └─ ─ ─ ─ ◀─────────────────
//                            │                                                                                                                                                                       │
//                                               │                   │                                                                                               │
//                            │                                                                                                                                                                       │
//                                               ▼                   │                                                                                               │
//                            │    ┌───────────────────────────┐                                                                                                      ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘
//                                 │                           │     │
//                            │    │       Show the view       │
//                                 │                           │     │
//                            │    └───────────────────────────┘
//                                                                   │
//                            └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
//

/// The view in charge of all the Deep-linking process.
/// For a detailed explanation of how this works, go to `Deeplinker.swift`
public class Deeplinker {

    /// The types of deeplinks that the application expects.
    enum Deeplink: Equatable, CaseIterable {

        static var allCases: [Deeplinker.Deeplink] {
            return [.home, .oauth(code: ""), .profile(id: "")]
        }

        case home
        case oauth(code: String)
        case profile(id: String)

        /// The keyword of the deeplink.
        var description: String {
            switch self {
            case .home:
                return "home"
            case .oauth:
                return "oauth"
            case .profile:
                return "profile"
            }
        }

        var expectsAssociatedValues: Int? {
            switch self {
            case .home:
                return nil
            case .oauth:
                return 1
            case .profile:
                return 1
            }
        }
        
    }

    /// A singleton everybody can access to.
    static public let shared = Deeplinker()

    func manage(url: URL) throws -> Deeplink {

        guard url.scheme == URL.appScheme else {
            throw DeeplinkError.unknownScheme(received: url.scheme)
        }

        for deeplink in Deeplink.allCases {
            if deeplink.description == url.host {

                //  We check that there are no other query parameters
                guard let queryItems = url.queryParameters else {

                    //  We make sure that the deeplink was not expecting any
                    //  parameter, and if so, we return the deeplink.
                    //
                    //  If the deeplink was actually expecting them, we return
                    //  error.
                    guard let values = deeplink.expectsAssociatedValues else {
                        return deeplink
                    }

                    throw DeeplinkError.expectedQueryParameters(expecting: values, received: 0)
                }

                //  Now, we make sure that the deeplink was actually expecting
                //  parameters, or else we return an error.
                guard deeplink.expectsAssociatedValues != nil else {
                    throw DeeplinkError.expectedQueryParameters(expecting: 0, received: queryItems.count)
                }

                switch url.host {
                case "oauth":
                    guard let code = queryItems.first(where: { $0.key == "code" })?.value else {
                        throw DeeplinkError.unknownQueryParameter(expecting: "code")
                    }
                    return .oauth(code: code)
                case "profile":
                    guard let id = queryItems.first(where: { $0.key == "id" })?.value else {
                        throw DeeplinkError.unknownQueryParameter(expecting: "id")
                    }
                    return .profile(id: id)
                default:
                    throw DeeplinkError.unknownDeeplink(received: url.host)
                }
            }

        }

        throw DeeplinkError.unknownDeeplink(received: url.host)

    }

}
