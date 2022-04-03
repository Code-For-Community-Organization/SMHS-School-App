//
//  GradesRubricRawResponse.swift
//  SMHS
//
//  Created by Jevon Mao on 11/26/21.
//

import Foundation

struct GradesRubricRawResponse: Codable {
    let d: D

    struct D: Codable {
        let results: [Category]
    }

    struct Category: Codable, Hashable {
        let type, category: String
        let percentOfGrade: Int
        let numberOfPoints: Double
        let maxPoints: Int
        let percentEarned: Double
        let mark: String
        let isShowingFinalMark, isHidingOverallScore, isDoingWeight: Bool
        let doingRubric: String
    }
}

