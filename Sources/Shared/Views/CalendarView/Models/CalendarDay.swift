//
//  CalendarDay.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/4/21.
//

import Foundation

struct CalendarDay: Codable {
    var date: Date
    var events: [CalendarEvent]
}
