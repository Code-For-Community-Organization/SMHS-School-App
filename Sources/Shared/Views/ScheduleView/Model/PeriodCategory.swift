//
//  NutritionScheduleSelection.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/10/21.
//

import Foundation

infix operator ~=~
enum PeriodCategory: String, Codable {
    case firstLunch, secondLunch, period, singleLunch,
         officeHour, firstLunchPeriod, secondLunchPeriod,
         unnumberedPeriod, passingPeriod
    
    var isLunch: Bool {
        [PeriodCategory.firstLunch, PeriodCategory.secondLunch, PeriodCategory.singleLunch].contains(self) //Match self for any of 3 specified cases
    }
    
    var isLunchRevolving: Bool {
        [PeriodCategory.firstLunch, PeriodCategory.secondLunch, PeriodCategory.firstLunchPeriod, PeriodCategory.secondLunchPeriod].contains(self) //Match self for any schedule related to 1st/2nd lunch
    }
    
    //Operator checks for categorical equality in lunch revolving periods
    static func ~=~(lhs: Self?, rhs: Self) -> Bool {
        let firstLunches: [PeriodCategory] = [.firstLunch, .firstLunchPeriod]
        let secondLunches: [PeriodCategory] = [.secondLunch, .secondLunchPeriod]
        guard let lhs = lhs else {return false}
        if lhs.isLunchRevolving
            && rhs.isLunchRevolving {
            if firstLunches.contains(lhs)
                && firstLunches.contains(rhs) {
                return true
            }
            else if secondLunches.contains(lhs)
                    && secondLunches.contains(rhs) {
                        return true
            }
            return false
        }
        return true
    }
}
