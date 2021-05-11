//
//  DateFormatter.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/8/21.
//

import Foundation

extension DateFormatter {
    static func formatTime12to24<Time: StringProtocol>(_ time: Time) -> Date? {
        //DateFormatter for 12hr time `String` to `Date`
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard var date = formatter.date(from: String(time)) else {return nil}
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        if calendar.component(.hour, from: date) <= 6 {
            date = calendar.date(byAdding: .hour, value: 12, to: date)!
        }
        return date
    }
}
