//
//  ClassPeriod.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/10/21.
//

import Foundation

struct ClassPeriod: Hashable, Codable {
    internal init(category: PeriodCategory, periodNumber: Int? = nil, startTime: Date, endTime: Date) {
        self.periodCategory = category
        self.periodNumber = periodNumber
        self.startTime = startTime
        self.endTime = endTime
    }
    internal init(category: PeriodCategory, periodNumber: Int, startTime: Date, endTime: Date) {
        self.periodCategory = category
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

    func getTitle() -> String {
        switch periodCategory {
        case .singleLunch:
            return "Nutrition"
        case .firstLunch:
            return "1st Lunch"
        case .secondLunch:
            return "2nd Lunch"
        case .period, .firstLunchPeriod, .secondLunchPeriod:
            let text = "Period \(String(periodNumber ?? -1))"
            return text.capitalized
        case .officeHour:
            return "Office Hour"
        case .unnumberedPeriod:
            return "\(title ?? "Period Block")".capitalized
        case .passingPeriod:
            return "Passing Period"
        }
    }

    func getUserClassName(userSettings: UserSettings) -> String? {
        if let matchingPeriod = userSettings.editableSettings.filter({$0.periodNumber == periodNumber}).first,
              matchingPeriod.textContent != "" {
            return matchingPeriod.textContent
        }
        return nil
    }
}

