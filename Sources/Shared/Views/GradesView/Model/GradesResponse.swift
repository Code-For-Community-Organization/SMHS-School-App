//
//  GradesResponse.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/27/21.
//

import Foundation

struct GradesResponse: Codable {
    var periodNum: Int
    var periodName: String
    var teacherName: String
    var gradePercent: Double
    var currentMark: String
    var isPrior: Bool
}
