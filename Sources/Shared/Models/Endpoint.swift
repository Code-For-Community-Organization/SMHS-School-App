//
//  Endpoint.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/27/21.
//

import Foundation

typealias c = Constants

struct Endpoint {
    var host: String
    var path: String
    var queryItems: [URLQueryItem]? = nil
    var requestHeaders: [String: String] = [:]
    var requestBody: [String: String] = [:]
    var httpMethod: RequestMethod
    var isApplicationJson = false
    var jsonEncode = false
    var isLogin = false

    enum RequestMethod: String {
        case POST, GET
    }
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
        request.cachePolicy = .returnCacheDataElseLoad
        request.httpMethod = httpMethod.rawValue
        if httpMethod == .POST {
            if jsonEncode {
                request.httpBody = try! JSONSerialization.data(withJSONObject: requestBody, options: [])
            }
            else {
                request.httpBody = requestBody.percentEncoded()
            }
        }
        let userAgent = AppVersionStatus.appDisplayName
        + "/"
        + AppVersionStatus.currentVersion!
        + " "
        + "Developer email/maoj@smhs.app"
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        request.setValue("br;q=1.0, gzip;q=0.9, deflate;q=0.8", forHTTPHeaderField: "Accept-Encoding")
        if isApplicationJson {
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        if isLogin {
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        return request
    }

    static func studentLogin(email: String,
                             password: String,
                             debugMode: Bool = false) -> Endpoint {
        let form = ["checkCookiesEnabled":"true",
                    "checkMobileDevice":"false",
                    "checkStandaloneMode":"false",
                    "checkTabletDevice":"false",
                    "portalAccountUsername": email,
                    "portalAccountPassword": password,
                    "portalAccountUsernameLabel": "",
                    "submit": ""]
        
        return Endpoint(host: c.AeriesApiPath.host,
                        path: c.AeriesApiPath.main,
                        requestBody: form,
                        httpMethod: .POST,
                        isLogin: true)

    }

    // This grades summary API used for getting
    // gradebook number which is critical for detailed grades
    static func getGradesSummary() -> Endpoint {
        Endpoint(host: c.AeriesApiPath.host,
                 path: c.AeriesApiPath.main + c.AeriesApiPath.summaryGrades,
                 httpMethod: .GET,
                 isApplicationJson: true)
    }

    // This grades summary API is supplement to
    // other one, for more precise percentage and teacher name
    static func getGradesSummarySupplement() -> Endpoint {
        Endpoint(host: c.AeriesApiPath.host,
                 path: c.AeriesApiPath.altGrades,
                 queryItems: [.init(name: "IsProfile", value: "true")],
                 httpMethod: .GET)
    }

    static func getDetailedGrades(term: String,
                                  gradebookNumber: String) -> Endpoint {
        let body = [
            "requestedPage": c.AeriesApiPath.requestedPage,
            "term": term,
            "pageSize": c.AeriesApiPath.pageSize,
            "gradebookNumber": gradebookNumber
        ]

        return Endpoint(host: c.AeriesApiPath.host,
                        path: c.AeriesApiPath.main + c.AeriesApiPath.detailedSummary,
                        requestBody: body,
                        httpMethod: .POST,
                        isApplicationJson: true,
                        jsonEncode: true)
    }

    // API for getting rubrics - weights and
    // categories of assessments and assignments.etc
    static func getGradesRubric(term: String,
                                gradebookNumber: String) -> Endpoint {
        let body = [
            "term": term,
            "gradebookNumber": gradebookNumber
        ]

        return Endpoint(host: c.AeriesApiPath.host,
                        path: c.AeriesApiPath.main + "/GetGradebookDetailedSummaryData",
                        requestBody: body,
                        httpMethod: .POST,
                        isApplicationJson: true,
                        jsonEncode: true)
    }

    static func getAnnoucements(daysFromToday: Int) -> Endpoint {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: -daysFromToday, to: Date()) ?? Date()
        return getAnnoucements(date: date)
    }

    static func getAnnoucements(date: Date) -> Endpoint {
        let formatter = DateFormatter()
        return Endpoint(host: c.SmhsApiPath.host,
                        path: c.SmhsApiPath.main + c.SmhsApiPath.annoucements,
                        queryItems: [.init(name: "date",
                                           value: formatter.serverTimeFormat(date))],
                        httpMethod: .GET)
    }

    static func getSchedule(date: Date) -> Endpoint {
        let formatter = DateFormatter()
        let c = c.AppServApiPath.self

        return Endpoint(host: c.host,
                        path: c.schedule,
                         queryItems: [.init(name: "i", value: "santamargaritahs"),
                                      .init(name: "pageSize", value: c.pageSize),
                                      .init(name: "pageNumber", value: c.pageNumber),
                                      .init(name: "dateStart", value: formatter.yearMonthDayFormat(date)),
                                      .init(name: "categoryId", value: c.categoryId),
                                      .init(name: "tz", value: "America%2FLos_Angeles"),
                                      .init(name: "mid", value: c.mid),
                                      .init(name: "smid", value: c.smid)],
                         httpMethod: .GET)
     }
    
}
