//
//  Endpoint.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/27/21.
//

import Foundation

struct Endpoint {
    var host: String
    var path: String
    var queryItems = [URLQueryItem]()
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }
    
    static func studentLogin(email: String, password: String) -> Endpoint {
        Endpoint(host: "aeries-student.herokuapp.com",
                 path: "/api/v1/grades",
                 queryItems: [.init(name: "email", value: email),
                              .init(name: "password", value: password)])
    }
    
    static func newsPosts(id: Int) -> Endpoint {
        Endpoint(host: "www.smhs.org",
                 path: "/fs/post-manager/boards/\(id)/posts/feed")
    }
}
