//
//  GradesDetailedRawResponse.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 9/23/21.
//

import Foundation

struct GradesDetailRawResponse: Decodable {
    let d: D

    struct D: Codable {
        let results: [GradesDetailContent]
        let total: Int
    }

    struct GradesDetailContent: Codable {
        let gradebookNumber, assignmentNumber: Int
            let resultDescription, type: String
            let isGraded, isScoreVisibleToParents, isScoreValueACheckMark: Bool
            let numberCorrect, numberPossible: Int
            let mark: String
            let score, maxScore: Int
            let percent: Double
            let dateAssigned, dateDue, dateCompleted, rubricAssignment: String

            enum CodingKeys: String, CodingKey {
                case gradebookNumber, assignmentNumber
                case resultDescription = "description"
                case type, isGraded, isScoreVisibleToParents, isScoreValueACheckMark, numberCorrect, numberPossible, mark, score, maxScore, percent, dateAssigned, dateDue, dateCompleted, rubricAssignment
            }
    }
}
