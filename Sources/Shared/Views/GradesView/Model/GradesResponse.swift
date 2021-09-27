//
//  GradesResponse.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/27/21.
//

import Foundation

struct GradesSummaryRawResponse: Decodable {
    let d: D

    struct D: Codable {
        let results: [Result]
    }

    enum Code: String, Codable {
        case dropped = "D"
        case none = ""
    }

    struct Result: Codable {
        let gradebookNumberTerm: String
        let gradebookNumber: Int
        let term: String
        let code: Code
        let period, mark, className: String
        let missingAssignments: Int
        let updated: String
        let trendDirection: String?
        let percentGrade: Int
        let comment: String
        let isUsingCheckMarks, hideOverallScore, showFinalMark, doingRubric: Bool
    }
}

struct CourseGrade: Codable, Hashable {
    var courses: [GradeSummary]

    enum CodingKeys: String, CodingKey {
        case courses
    }

    struct GradeSummary: Hashable, Codable {
        var periodNum: String
        var periodName: String
        var gradePercent: Double
        var currentMark: String
        var gradebookNumber: Int
        var code: GradesSummaryRawResponse.Code
        var term: String
        var teacherName: String = ""
        var lastUpdated: String = ""
    }

    init(_ courses: [CourseGrade.GradeSummary]) {
        self.courses = courses
    }


    func encode(to encoder: Encoder) throws {
        var encoder = encoder.container(keyedBy: CodingKeys.self)
        try encoder.encode(courses, forKey: .courses)
    }


    init(from decoder: Decoder) throws {
        let decoder = try GradesSummaryRawResponse(from: decoder)
        courses = decoder.d.results.map {
            GradeSummary(periodNum: $0.period,
                         periodName: $0.className,
                         gradePercent: Double($0.percentGrade),
                         currentMark: $0.mark,
                         gradebookNumber: $0.gradebookNumber,
                         code: $0.code,
                         term: $0.term)
        }
    }

    static let dummyGrades = CourseGrade([.init(periodNum: "1",
                                                periodName: "Journalism 1 H",
                                                gradePercent: 98,
                                                currentMark: "A+",
                                                gradebookNumber: 69696969,
                                                code: .none,
                                                term: "F")])
//    static let dummyGrades: CourseGrade = .init(periodNum: 1,
//                                                   periodName: "Precalculus H AI IB",
//                                                   teacherName: "CookT",
//                                                   gradePercent: "69.7",
//                                                   currentMark: "D+"),
//                                             .init(periodNum: 2,
//                                                   periodName: "Journalism 1 H",
//                                                   teacherName: "AppleseedJ",
//                                                   gradePercent: "98.8",
//                                                   currentMark: "A+"),
//                                             .init(periodNum: 3,
//                                                   periodName: "AP Physics C",
//                                                   teacherName: "MuskE",
//                                                   gradePercent: "90.5",
//                                                   currentMark: "A-"),
//                                             .init(periodNum: 4,
//                                                   periodName: "Religion 2",
//                                                   teacherName: "RileyT",
//                                                   gradePercent: "74.3",
//                                                   currentMark: "C"),
//                                             .init(periodNum: 5,
//                                                   periodName: "History MUN H",
//                                                   teacherName: "WashingtonG",
//                                                   gradePercent: "64.9",
//                                                   currentMark: "F"),
//                                             .init(periodNum: 6,
//                                                   periodName: "French 3",
//                                                   teacherName: "TrumpD",
//                                                   gradePercent: "100.5",
//                                                   currentMark: "A+")
}
