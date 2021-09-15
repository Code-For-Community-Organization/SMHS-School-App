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
        ForEach(periods, id: \.self){period in
            PeriodBlockItem(block: period)
        }
    }

}

