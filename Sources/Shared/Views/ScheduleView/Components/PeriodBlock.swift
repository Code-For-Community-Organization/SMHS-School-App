//
//  PeriodBlock.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/21/21.
//

import SwiftUI

struct PeriodBlock: View {
    var periods: [ClassPeriod]
    var body: some View {
        ForEach(periods, id: \.self){period in
            switch period.periodCategory
            {
            case .singleLunch:
                PeriodBlockItem(block: period, scheduleTitle: "Nutrition")
            case .period:
                PeriodBlockItem(block: period, scheduleTitle: "Period \(String(period.periodNumber ?? -1))")
            case .officeHour:
                PeriodBlockItem(block: period, scheduleTitle: "Office Hour")
            default:
                Text("Please report this bug.")
        }
    }
    }
}

