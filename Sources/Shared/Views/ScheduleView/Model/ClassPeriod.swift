//
//  ClassPeriod.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/10/21.
//

import Foundation

struct ClassPeriod: Hashable, Codable {
    internal init(nutritionBlock: PeriodCategory,
                  periodNumber: Int? = nil,
                  startTime: Date,
                  endTime: Date,
                  date: Date)
    {
        periodCategory = nutritionBlock
        self.periodNumber = periodNumber
        self.startTime = startTime
        self.endTime = endTime
        self.date = date
    }

    internal init(nutritionBlock: PeriodCategory,
                  periodNumber: Int,
                  startTime: Date,
                  endTime: Date,
                  date: Date)
    {
        periodCategory = nutritionBlock
        self.periodNumber = periodNumber
        self.startTime = startTime
        self.endTime = endTime
        self.date = date
    }

    internal init(_ title: String, startTime: Date, endTime: Date, date: Date) {
        self.title = title
        periodCategory = .unnumberedPeriod
        self.startTime = startTime
        self.endTime = endTime
        self.date = date
    }

    var periodCategory: PeriodCategory
    var title: String?
    var periodNumber: Int?

    var startTime: Date
    var startDate: Date {
        appendDate(time: startTime, date: date)
    }

    var endTime: Date
    var endDate: Date {
        appendDate(time: endTime, date: date)
    }

    var date: Date

    func appendDate(time: Date, date: Date) -> Date {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let timeComponent = calendar.dateComponents([.hour, .minute, .second], from: time)
        let dateComponent = calendar.dateComponents([.year, .month, .day], from: date)

        var newDate = DateComponents()
        newDate.hour = timeComponent.hour
        newDate.minute = timeComponent.minute
        newDate.year = dateComponent.year
        newDate.month = dateComponent.month
        newDate.day = dateComponent.day
        return calendar.date(from: newDate)!
    }
}
