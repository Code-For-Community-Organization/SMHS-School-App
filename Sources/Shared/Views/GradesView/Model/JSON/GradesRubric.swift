//
//  GradesRubric.swift
//  SMHS
//
//  Created by Jevon Mao on 11/26/21.
//

import Foundation

struct GradesRubric: Codable, Hashable {
    var categories: [GradesRubricRawResponse.Category]

    init(from decoder: Decoder) throws {
        let rawResponse = try GradesRubricRawResponse(from: decoder)
        self.categories = rawResponse.d.results
    }
}
