//
//  Date.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/1/21.
//

import Foundation

extension Date {
    static func currentWeekday(for date: Date = Date()) -> Int { Calendar.current.component(.weekday, from: date) - 1 }

    static func getDayOfTheWeek(for date: Date = Date()) -> Int { Calendar.current.component(.weekday, from: date) - 1 }

    func isBetween(_ date1: Date, and date2: Date) -> Bool { (min(date1, date2) ... max(date1, date2)).contains(self) }

    static func - (_ lhs: Date, _ rhs: Date) -> TimeInterval { lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate }

    func localDate() -> Date {
        let nowUTC = self
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else { return Date() }

        return localDate
    }

    func convertToReferenceDateLocalTime(convert: Bool = true) -> Date {
        let localDate = convert ? self.localDate() : self
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: localDate)
        dateComponents.year = 2000
        dateComponents.month = 1
        dateComponents.day = 1
        let newDate = calendar.date(from: dateComponents)!
        return newDate
    }

    // https://stackoverflow.com/questions/27182023/getting-the-difference-between-two-dates-months-days-hours-minutes-seconds-in
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }

    func eraseTime() -> Date {
        Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
}
