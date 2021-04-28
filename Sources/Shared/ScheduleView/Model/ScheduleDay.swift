//
//  ClassPeriod.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import Foundation

struct ScheduleDay: Hashable, Identifiable, Codable {
    var id: Int
    var date: Date
    var scheduleText: String
    var title: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }
}
