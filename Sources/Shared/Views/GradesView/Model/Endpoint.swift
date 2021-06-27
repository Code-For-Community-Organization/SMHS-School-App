//
//  Endpoint.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/27/21.
//

import Foundation

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem]
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "aeries-student.herokuapp.com"
        components.path = "/api/v1/" + path
        components.queryItems = queryItems
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }
    
    static func studentLogin(email: String, password: String) -> Endpoint {
        Endpoint(path: "/grades",
                 queryItems: [.init(name: "email", value: email),
                              .init(name: "password", value: password)])
    }
}
