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
        formatter.dateFormat = "H:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: String(time))
    }
}
