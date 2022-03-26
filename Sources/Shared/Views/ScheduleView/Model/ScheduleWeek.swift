//
//  ScheduleWeek.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 4/25/21.
//

import Foundation

struct ScheduleWeek: Hashable, Codable {
    var startDate: Date? {scheduleDays.first?.date ?? nil}
    var endDate: Date? {scheduleDays.last?.date ?? nil}
    var weekText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/dd"
        if let startDate = startDate, let endDate = endDate {
            let startDate = dateFormatter.string(from: startDate)
            let endDate = dateFormatter.string(from: endDate)
            return "Week of \(startDate) to \(endDate)"
        }
        else {
            return ""
        }
    }
    var scheduleDays: [ScheduleDay]
    
    subscript(dayIndex: Int) -> ScheduleDay {
        get {
            scheduleDays[dayIndex]
        }
        set {
            scheduleDays[dayIndex] = newValue
        }
    }
    
    func getDayByDate(_ date: Date) -> ScheduleDay? {
        scheduleDays.first{$0.date == date.eraseTime()}
    }

    func isLast(day: ScheduleDay) -> Bool {
        return day == scheduleDays.last
    }
//
//    func contains(_ date: Date) -> Bool {
//        guard let startDate = startDate, let endDate = endDate else {
//            return false
//        }
//        return date > startDate && date < endDate
//    }
}

extension ScheduleWeek: Equatable {
    static func == (lhs: ScheduleWeek, rhs: ScheduleWeek) -> Bool {
        return lhs.startDate == rhs.startDate
            && lhs.endDate == rhs.endDate
    }
}
