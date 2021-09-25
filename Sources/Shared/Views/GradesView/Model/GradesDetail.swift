//
//  GradesDetail.swift
//  SMHS
//
//  Created by Jevon Mao on 9/23/21.
//

import Foundation

struct GradesDetail: Decodable {
    var assignments: [Assignment]

    struct Assignment: Hashable {
        // MARK: Name & Description
        var description: String
        var category: String

        // MARK: Scores
        var numberCorrect: Int
        var numberPossible: Int
        var percent: Double

        // MARK: Other Information
        // Whether is missing
        var dateCompleted: String?
        var isGraded: Bool
    }

    init(from decoder: Decoder) throws {
        let rawResponse = try GradesDetailRawResponse(from: decoder)
        assignments = rawResponse.d.results.map {
            Assignment(description: $0.resultDescription,
                              category: $0.type,
                              numberCorrect: $0.numberCorrect,
                              numberPossible: $0.numberPossible,
                              percent: $0.percent,
                              dateCompleted: $0.dateCompleted,
                              isGraded: $0.isGraded)
        }
    }
}
