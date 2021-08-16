//
//  PeriodBlock.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/21/21.
//

import SwiftUI

struct PeriodBlockSubview: View {
    var periods: [ClassPeriod]
    var body: some View {
        ForEach(periods, id: \.self) { period in
            PeriodBlockItem(block: period,
                            scheduleTitle: getTitle(period))
        }
    }

    func getTitle(_ period: ClassPeriod) -> String {
        switch period.periodCategory {
        case .singleLunch:
            return "Nutrition"
        case .period:
            let text = "Period \(String(period.periodNumber ?? -1))"
            return text.autoCapitalized
        default:
            return "\(period.title ?? "Period Block")".autoCapitalized
        }
    }
}
