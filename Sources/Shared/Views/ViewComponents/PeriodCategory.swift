//
//  NutritionScheduleSelection.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/10/21.
//

import Foundation

enum PeriodCategory: String, Codable {
    case firstLunch, secondLunch, period, singleLunch, officeHour, firstLunchPeriod, secondLunchPeriod
    var isLunch: Bool {
        [PeriodCategory.firstLunch, PeriodCategory.secondLunch, PeriodCategory.singleLunch].contains(self) //Match self for any of 3 specified cases
    }
    
    var isLunchRevolving: Bool {
        [PeriodCategory.firstLunch, PeriodCategory.secondLunch, PeriodCategory.firstLunchPeriod, PeriodCategory.secondLunchPeriod].contains(self) //Match self for any schedule related to 1st/2nd lunch
    }
}
