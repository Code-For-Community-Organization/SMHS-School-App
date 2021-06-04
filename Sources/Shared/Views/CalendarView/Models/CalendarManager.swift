//
//  CalendarManager.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/4/21.
//

import Foundation
import CoreGraphics

struct CalendarManager: Codable {
    var days = [Date: CalendarDay]()
    
    func getNumberOfEvents(forDay date: Date) -> Int {days[date]?.events.count ?? 0}
    
    func getOpacity(forDay date: Date) -> Double
    {
        (Double(getNumberOfEvents(forDay: date)) + 3.0) / 8.0
    }
}
