//
//  DateFormatter.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/8/21.
//

import Foundation

extension DateFormatter {
    static func getLocalTimeFormatter(withFormat dateFormat: String) -> DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
    static func formatTime12to24<Time: StringProtocol>(_ time: Time) -> Date? {
        //DateFormatter for 12hr time `String` to `Date`
        let formatter = getLocalTimeFormatter(withFormat: "h:mm")
        guard var date = formatter.date(from: String(time)) else {return nil}
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        if calendar.component(.hour, from: date) <= 6 {
            date = calendar.date(byAdding: .hour, value: 12, to: date)!
        }
        return date
    }

    func serverTimeFormat(_ time: String?) -> Date? {
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let time = time
        else {
            return nil
        }
        return self.date(from: time)
    }

    func serverTimeFormat(_ date: Date) -> String {
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return self.string(from: date)
    }

    static func hourTimeFormat(_ time: String) -> Date? {
        let formatter = getLocalTimeFormatter(withFormat: "h:mma")
        return formatter.date(from: time)
    }

    func yearMonthDayFormat(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
