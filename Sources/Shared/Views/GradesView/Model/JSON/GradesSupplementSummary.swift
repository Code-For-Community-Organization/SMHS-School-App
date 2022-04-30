//
//  GradesSupplementSummary.swift
//  SMHS
//
//  Created by Jevon Mao on 9/26/21.
//

import Foundation

struct GradesSupplementSummary: Codable {
    let period: Int
    let roomNumber, courseNumber, courseName, courseNumberAndName: String
    let sectionNumber: String
    let gradebookName, gradebookNumber: JSONNull?
    let teacherName, gradebook, percent, average: String
    let currentMark, currentMarkAndScore, currentPercentOrAverage: String
    let doingMinMax: Bool
    let trend, missingAssignments: String
    let numMissingAssignments: Int
    let lastATT, lastUpdated, totalStudents, website: String
    let accessCode, source, term: String
    let termGrouping: TermGrouping
    let schoolNumber: Int
    let schoolName: String
    let schoolSort: SchoolSort
    let districtCDS: String
    let districtName: String
    let editable, block: Int
    let doingRubric: Bool
    let termCode: JSONNull?
    let onlineMeetingURL, onlineMeetingAccessCode, onlineMeetingSource, onlineMeetingPhoneNumber: String
    let onlineMeetingNote, periodTitle: String
    let flexShortTitle: JSONNull?
    let flexPeriodStartTime, flexPeriodEndTime: FlexPeriodTime
    let students: JSONNull?

    enum CodingKeys: String, CodingKey {
        case period = "Period"
        case roomNumber = "RoomNumber"
        case courseNumber = "CourseNumber"
        case courseName = "CourseName"
        case courseNumberAndName = "CourseNumberAndName"
        case sectionNumber = "SectionNumber"
        case gradebookName = "GradebookName"
        case gradebookNumber = "GradebookNumber"
        case teacherName = "TeacherName"
        case gradebook = "Gradebook"
        case percent = "Percent"
        case average = "Average"
        case currentMark = "CurrentMark"
        case currentMarkAndScore = "CurrentMarkAndScore"
        case currentPercentOrAverage = "CurrentPercentOrAverage"
        case doingMinMax = "DoingMinMax"
        case trend = "Trend"
        case missingAssignments = "MissingAssignments"
        case numMissingAssignments = "NumMissingAssignments"
        case lastATT = "LastATT"
        case lastUpdated = "LastUpdated"
        case totalStudents = "TotalStudents"
        case website = "Website"
        case accessCode = "AccessCode"
        case source = "Source"
        case term = "Term"
        case termGrouping = "TermGrouping"
        case schoolNumber = "SchoolNumber"
        case schoolName = "SchoolName"
        case schoolSort = "SchoolSort"
        case districtCDS = "DistrictCDS"
        case districtName = "DistrictName"
        case editable = "EDITABLE"
        case block = "Block"
        case doingRubric = "DoingRubric"
        case termCode = "TermCode"
        case onlineMeetingURL = "OnlineMeetingURL"
        case onlineMeetingAccessCode = "OnlineMeetingAccessCode"
        case onlineMeetingSource = "OnlineMeetingSource"
        case onlineMeetingPhoneNumber = "OnlineMeetingPhoneNumber"
        case onlineMeetingNote = "OnlineMeetingNote"
        case periodTitle = "PeriodTitle"
        case flexShortTitle = "FlexShortTitle"
        case flexPeriodStartTime = "FlexPeriodStartTime"
        case flexPeriodEndTime = "FlexPeriodEndTime"
        case students = "Students"
    }
}

enum FlexPeriodTime: String, Codable {
    case date62135568000000 = "/Date(-62135568000000)/"
}

enum SchoolSort: String, Codable {
    case the1 = "_1"
}

enum TermGrouping: String, Codable {
    case current = "Current Terms"
    case dropped = "Dropped Gradebooks"
    case prior = "Prior Terms"
}

typealias Welcome = [GradesSupplementSummary]

// MARK: - Encode/decode helpers

struct JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    func hash(into hasher: inout Hasher) {}

    public init() {}

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
