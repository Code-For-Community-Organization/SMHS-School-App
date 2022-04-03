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

    enum Term: String, Codable {
        case fall = "F"
        case spring = "S"
    }

    enum TrendDirection: String, Codable {
        case down = "DOWN"
        case same = "SAME"
        case up = "UP"
    }

    enum Code: String, Codable {
        case dropped = "D"
        case prior = "P"
        case current = ""

    }

    struct Result: Codable {
        let gradebookNumberTerm: String
        let gradebookNumber: Int
        let term: Term
        let code: Code
        let period, mark, className: String
        let missingAssignments: Int
        let updated: String
        let trendDirection: TrendDirection?
        let percentGrade: Int
        let comment: String
        let isUsingCheckMarks, hideOverallScore, showFinalMark, doingRubric: Bool
    }
}

