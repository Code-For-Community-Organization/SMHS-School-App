//
//  ScheduleWeek.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 4/25/21.
//

import Foundation

struct ScheduleWeek: Hashable {
    var startDate: Date? {scheduleDays.first?.date ?? nil}
    var endDate: Date? {scheduleDays.last?.date ?? nil}
    var weekText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
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
}
