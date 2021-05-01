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
}
