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
    var httpMethod = "POST"
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
        request.httpMethod = httpMethod
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

    static func getAnnoucements(daysFromToday: Int) -> Endpoint {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: -daysFromToday, to: Date()) ?? Date()
        return getAnnoucements(date: date)
    }

    static func getAnnoucements(date: Date) -> Endpoint {
        let formatter = DateFormatter()
        return Endpoint(path: "/annoucements",
                        queryItems: [.init(name: "date",
                                           value: formatter.serverTimeFormat(date))],
                        httpMethod: "GET")
    }
    
}
