//
//  ClassPeriod.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/10/21.
//

import Foundation

struct ClassPeriod: Hashable, Codable  {
    internal init(nutritionBlock: PeriodCategory, periodNumber: Int? = nil, startTime: Date, endTime: Date) {
        self.periodCategory = nutritionBlock
        self.periodNumber = periodNumber
        self.startTime = startTime
        self.endTime = endTime
    }
    internal init(nutritionBlock: PeriodCategory, periodNumber: Int, startTime: Date, endTime: Date) {
        self.periodCategory = nutritionBlock
        self.periodNumber = periodNumber
        self.startTime = startTime
        self.endTime = endTime
    }
    internal init(_ title: String, startTime: Date, endTime: Date) {
        self.title = title
        self.periodCategory = .unnumberedPeriod
        self.startTime = startTime
        self.endTime = endTime
    }
    var periodCategory: PeriodCategory
    var title: String?
    var periodNumber: Int?
    var startTime: Date
    var endTime: Date
}

