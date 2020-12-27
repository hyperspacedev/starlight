//
//  Endpoint.swift
//  Hyperspace
//
//  Created by Alejandro Modroño Vara on 26/12/20.
//

import Foundation

/// Reusable base Endpoint struct. It is used everytime we try to interact with the fediverse.
public struct Endpoint: CustomStringConvertible {

    public var path: String
    public var queryItems: [URLQueryItem] = []
    public var baseURL: String
    public var headers = [String: Any]()

    init(_ baseURL: String, _ path: String, queryItems: [URLQueryItem], headers: [String: Any] = [:]) {
        self.baseURL = baseURL
        self.headers = headers
        self.path = path
        self.headers = headers

    }
}

/// Dummy API specific Endpoint extension
extension Endpoint {

    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseURL
        components.path = "/api/v1" + self.path
        components.queryItems = queryItems

        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }

        return url
    }

    var request: URLRequest {
        return URLRequest(url: self.url)
    }

}

/// Dummy API endpoints
//extension Endpoint {
//    static var posts: Self {
//        return self(path: "/posts")
//    }
//
//    static var categories: Self {
//        return Endpoint(path: "/posts")
//    }
//
//    static func users(count: Int) -> Self {
//        return Endpoint(path: "/user",
//                        queryItems: [
//                            URLQueryItem(name: "limit",
//                                         value: "\(count)")
//            ]
//        )
//    }
//
//    static func user(identifier: String) -> Self {
//        return Endpoint(path: "/user/\(identifier)")
//    }
//}
