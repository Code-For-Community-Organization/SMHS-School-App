//
//  CalendarEvent.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/4/21.
//

import Foundation

struct CalendarEvent: Hashable, Codable {
    var title: String
    var isFullDay: Bool = false
    var startTime: Date?
    var endTime: Date?
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter
    }
    var startTimeText: String {dateFormatter.string(from: startTime ?? Date())}
    var endTimeText: String {dateFormatter.string(from: endTime ?? Date())}
}
