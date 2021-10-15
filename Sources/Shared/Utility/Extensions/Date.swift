//
//  Date.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/1/21.
//

import Foundation

extension Date {
    
    static func currentWeekday(for date: Date = Date()) -> Int {Calendar.current.component(.weekday, from: date)-1}
    
    static func getDayOfTheWeek(for date: Date = Date()) -> Int {Calendar.current.component(.weekday, from: date)-1}
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {(min(date1, date2) ... max(date1, date2)).contains(self)}
    
    static func - (_ lhs: Date, _ rhs: Date) -> TimeInterval {lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate}
    
    func localDate() -> Date {
        let nowUTC = self
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}
        
        return localDate
    }

    func convertToReferenceTime() -> Date {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.hour, .minute, .second], from: self)
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let newDate = calendar.date(from: dateComponents)!
        return newDate
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
    //https://stackoverflow.com/questions/27182023/getting-the-difference-between-two-dates-months-days-hours-minutes-seconds-in
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    
    func eraseTime() -> Date {
         Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }

    //https://stackoverflow.com/questions/44086555/swift-display-time-ago-from-date-nsdate
    func timeAgoDisplay() -> String {

            let calendar = Calendar.current
            let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
            let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
            let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
            
            if minuteAgo < self {
                let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
                guard diff > 0 else {
                    return "just now"
                }
                return "\(diff) sec ago"
            } else if hourAgo < self {
                let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
                return "\(diff) min ago"
            } else if dayAgo < self {
                let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
                return "\(diff) hrs ago"
            } else if weekAgo < self {
                let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
                return "\(diff) days ago"
            }
            let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
            return "\(diff) weeks ago"
        }
}

extension TimeInterval {
    func secondsToHoursMinutesSeconds () -> (Int, Int, Int) {(Int(self) / 3600, (Int(self) % 3600) / 60, (Int(self) % 3600) % 60)}
}

