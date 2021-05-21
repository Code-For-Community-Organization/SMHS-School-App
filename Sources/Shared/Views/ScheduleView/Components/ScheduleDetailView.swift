//
//  ScheduleCardView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI
import SFSafeSymbols

struct ScheduleDetailView: View {
    var scheduleDay: ScheduleDay?
    //Periods before lunch, 1st out of 3 UI sections
    var preLunchPeriods: [ClassPeriod] {
        let firstIndex = scheduleDay?.periods.firstIndex{$0.periodCategory?.isLunchRevolving ?? false} //First index found of 1st/2nd type block
        guard let firstIndex = firstIndex,
              let scheduleDay = scheduleDay else
        {
            return scheduleDay?.periods ?? [] //Fallback on all periods, assuming no lunch or single lunch
            
        }
        return Array(scheduleDay.periods[0..<firstIndex])
    }
    
    //1st or 2nd lunch revolving periods, 2nd out of 3 UI sections
    var lunchPeriods: [ClassPeriod] {
        let firstIndex = scheduleDay?.periods.firstIndex{$0.periodCategory?.isLunchRevolving ?? false}
        let lastIndex = scheduleDay?.periods.lastIndex{$0.periodCategory?.isLunchRevolving ?? false} //Last instance 1st/2nd nutrition block
        guard let firstIndex = firstIndex,
              let lastIndex = lastIndex,
              let scheduleDay = scheduleDay else {return []}
        return Array(scheduleDay.periods[firstIndex...lastIndex])
    }
    
    //Periods after lunch, 3rd out of 3 UI sections
    var postLunchPeriods: [ClassPeriod] {
        let lastIndex = scheduleDay?.periods.lastIndex{$0.periodCategory?.isLunchRevolving ?? false}
        guard let lastIndex = lastIndex, let scheduleDay = scheduleDay else {return []}
        return Array(scheduleDay.periods.suffix(from: lastIndex + 1)) //lastIndex + 1 to shorten array, remove unwanted
    }
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(preLunchPeriods, id: \.self){period in
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
                Text("WIP - Some random shit")
                ForEach(postLunchPeriods, id: \.self){period in
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
            .padding(.horizontal)
        }.navigationBarTitleDisplayMode(.inline)
        
        
        
    }
    
}

//struct ScheduleCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        UIElementPreview(ClassScheduleView.previewClassScheduleView)
//    }
//}
