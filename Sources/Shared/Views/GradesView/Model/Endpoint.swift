//
//  Endpoint.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/27/21.
//

import Foundation

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
    var requestHeaders: [String: String] = [:]
}

extension Endpoint {
    private var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "aeries-student.herokuapp.com"
        components.path = "/api/v1" + path
        components.queryItems = queryItems
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }
    
    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = requestHeaders
        request.httpBody = requestHeaders.percentEncoded()
        return request
    }
    
    static func studentLogin(email: String,
                             password: String,
                             debugMode: Bool = false) -> Endpoint {
        let headers = ["email": email, "password": password]
        if debugMode {
            return Endpoint(path: "/grades/",
                     queryItems: [.init(name: "reload", value: "false")],
                     requestHeaders: headers)
        }
        else {
            return Endpoint(path: "/grades/",
                     requestHeaders: headers)
        }
            
  
    }
    
}
