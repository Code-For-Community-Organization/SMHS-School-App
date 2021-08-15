//
//  GradesResponse.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/27/21.
//

import Foundation

struct CourseGrade: Codable, Hashable {
    var periodNum: Int
    var periodName: String
    var teacherName: String
    var gradePercent: String
    var currentMark: String
    var isPrior: Bool = false

    static let dummyGrades: [CourseGrade] = [.init(periodNum: 1,
                                                   periodName: "Precalculus H AI IB",
                                                   teacherName: "CookT",
                                                   gradePercent: "69.7",
                                                   currentMark: "D+"),
                                             .init(periodNum: 2,
                                                   periodName: "Journalism 1 H",
                                                   teacherName: "AppleseedJ",
                                                   gradePercent: "98.8",
                                                   currentMark: "A+"),
                                             .init(periodNum: 3,
                                                   periodName: "AP Physics C",
                                                   teacherName: "MuskE",
                                                   gradePercent: "90.5",
                                                   currentMark: "A-"),
                                             .init(periodNum: 4,
                                                   periodName: "Religion 2",
                                                   teacherName: "RileyT",
                                                   gradePercent: "74.3",
                                                   currentMark: "C"),
                                             .init(periodNum: 5,
                                                   periodName: "History MUN H",
                                                   teacherName: "WashingtonG",
                                                   gradePercent: "64.9",
                                                   currentMark: "F"),
                                             .init(periodNum: 6,
                                                   periodName: "French 3",
                                                   teacherName: "TrumpD",
                                                   gradePercent: "100.5",
                                                   currentMark: "A+")]
}
