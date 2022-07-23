//
//  GradesRubric.swift
//  SMHS
//
//  Created by Jevon Mao on 11/26/21.
//

import Foundation

struct GradesRubric: Hashable, Codable {
    let rubrics: [Rubric]

    struct Rubric: Hashable, Codable {
        let category: String
        let percentOfGrade: Int
        let isDoingWeight: Bool
    }

    init(from decoder: Decoder) throws {
        let rawResponse = try GradesRubricRawResponse(from: decoder)
        self.rubrics = rawResponse.d.results
            .map {
                .init(category: $0.category,
                             percentOfGrade: $0.percentOfGrade,
                             isDoingWeight: $0.isDoingWeight)
            }
    }
}





