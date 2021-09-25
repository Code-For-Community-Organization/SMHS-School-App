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
    var queryItems: [URLQueryItem] = []
    var requestHeaders: [String: String] = [:]
    var requestBody: [String: String] = [:]
    var httpMethod = "POST"
    var isApplicationJson = false
}

extension Endpoint {
    private var url: URL {
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
    
    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = requestHeaders
        request.httpBody = requestBody.percentEncoded()
//        if let bodyData = try? JSONSerialization.data(withJSONObject: requestBody, options: []),
//        httpMethod == "POST" {
//            request.httpBody = bodyData
//        }
        if isApplicationJson {
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        return request
    }

    static let SMHS_API_HOST = "api.smhs.app"
    static let SMHS_API_MAIN_PATH = "/api/v1"

    static let AERIES_API_HOST = "aeries.smhs.org"
    static let AERIES_API_MAIN_PATH = "/parent/m/api/MobileWebAPI.asmx"
    static let AERIES_API_LOGIN_PATH = "/parent/LoginParent.aspx"

    static func studentLogin(email: String,
                             password: String,
                             debugMode: Bool = false) -> Endpoint {
        let form = ["checkCookiesEnabled":"true",
                      "checkMobileDevice":"false",
                      "checkStandaloneMode":"false",
                      "checkTabletDevice":"false",
                    "portalAccountUsername": email,
                    "portalAccountPassword": password]
        
        return Endpoint(host: AERIES_API_HOST,
                        path: AERIES_API_LOGIN_PATH,
                        requestBody: form,
                        httpMethod: "POST")

    }

    static func getGradesSummary() -> Endpoint {
        Endpoint(host: AERIES_API_HOST,
                 path: AERIES_API_MAIN_PATH + "/GetGradebookSummaryData",
                 httpMethod: "GET",
                 isApplicationJson: true)
    }

    static func getDetailedGrades(term: String,
                                  gradebookNumber: String) -> Endpoint {
        let body = [
            "requestedPage": "1",
            "term": "F",
            "pageSize": "200",
            "gradebookNumber": gradebookNumber
        ]

        return Endpoint(host: AERIES_API_HOST,
                        path: AERIES_API_MAIN_PATH + "/GetGradebookDetailsData",
                        requestBody: body,
                        httpMethod: "POST",
                        isApplicationJson: true)
    }

    static func getAnnoucements(daysFromToday: Int) -> Endpoint {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: -daysFromToday, to: Date()) ?? Date()
        return getAnnoucements(date: date)
    }

    static func getAnnoucements(date: Date) -> Endpoint {
        let formatter = DateFormatter()
        return Endpoint(host: SMHS_API_HOST,
                        path: SMHS_API_MAIN_PATH + "/announcements",
                        queryItems: [.init(name: "date",
                                           value: formatter.serverTimeFormat(date))],
                        httpMethod: "GET")
    }
    
}
