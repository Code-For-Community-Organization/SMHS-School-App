//
//  Date.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/1/21.
//

import Foundation

extension Date {
    
    static var currentWeekday: Int {
        get {
            Calendar.current.component(.weekday, from: Date())-1
        }
    }
    
    static func getDayOfTheWeek(for date: Date) -> Int {
        Calendar.current.component(.weekday, from: date)-1
    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    static func - (_ lhs: Date, _ rhs: Date) -> TimeInterval {
        lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    func localDate() -> Date {
            let nowUTC = Date()
            let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
            guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

            return localDate
    }
    
    func convertToReferenceDateLocalTime() -> Date? {
        let localDate = self.localDate()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: localDate)
        dateComponents.year = 2000
        dateComponents.month = 1
        dateComponents.day = 1
        let newDate = calendar.date(from: dateComponents)
        return newDate
    }
}

extension TimeInterval {
    func secondsToHoursMinutesSeconds () -> (Int, Int, Int) {
      return (Int(self) / 3600, (Int(self) % 3600) / 60, (Int(self) % 3600) % 60)
    }
}


