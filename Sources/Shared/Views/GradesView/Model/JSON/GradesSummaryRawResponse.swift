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
