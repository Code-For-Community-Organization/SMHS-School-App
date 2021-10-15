//
//  ScheduleCardView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI
import SFSafeSymbols
import FirebaseAnalytics

struct ScheduleDetailView: View {
    @EnvironmentObject var userSettings: UserSettings
    var scheduleDay: ScheduleDay?
    //Periods before lunch, 1st out of 3 UI sections
    var preLunchPeriods: [ClassPeriod] {
        let firstIndex = scheduleDay?.periods.firstIndex{$0.periodCategory.isLunchRevolving}
        if let firstIndex = firstIndex,
           let scheduleDay = scheduleDay {
            return Array(scheduleDay.periods[0..<firstIndex])
        }
        
        return scheduleDay?.periods ?? [] //Fallback on all periods, assuming no lunch or single lunch
    }
    
    //1st or 2nd lunch revolving periods, 2nd out of 3 UI sections
    var lunchPeriods: [ClassPeriod] {
        let firstIndex = scheduleDay?.periods.firstIndex{$0.periodCategory.isLunchRevolving}
        let lastIndex = scheduleDay?.periods.lastIndex{$0.periodCategory.isLunchRevolving} //Last instance 1st/2nd nutrition block
        if let firstIndex = firstIndex,
              let lastIndex = lastIndex,
              let scheduleDay = scheduleDay {
            return Array(scheduleDay.periods[firstIndex...lastIndex])
        }
        return []
    }
    
    //Periods after lunch, 3rd out of 3 UI sections
    var postLunchPeriods: [ClassPeriod] {
        let lastIndex = scheduleDay?.periods.lastIndex{$0.periodCategory.isLunchRevolving}
        if let lastIndex = lastIndex, let scheduleDay = scheduleDay  {
            let removingPeriod8 = scheduleDay.periods.filter {$0.periodNumber != 8}
            //lastIndex + 1 to shorten array, remove unwanted
            return Array(removingPeriod8.suffix(from: lastIndex + 1))
        }
        return []
    }

    var period8: ClassPeriod? {
        scheduleDay?.periods.filter {$0.periodNumber == 8}.first
    }

    var scheduleDateDescription: String {
         let date = scheduleDay?.date ?? Date()
         let format = DateFormatter()
         format.dateFormat = "EEEE, MMM d"
         let formattedDate = format.string(from: date)
         return formattedDate
    }

    var horizontalPadding = true

    var body: some View {
        ScrollView {
            if userSettings.preferLegacySchedule {
                ScheduleViewTextLines(scheduleLines: scheduleDay?.scheduleText.lines)
            }
            else {
                LazyVStack(spacing: 10) {
                    PeriodBlockSubview(periods: preLunchPeriods)

                    if let firstLunch = lunchPeriods.first{$0.periodCategory == .firstLunch},
                       let firstLunchPeriod = lunchPeriods.first{$0.periodCategory == .firstLunchPeriod},
                       let secondLunch = lunchPeriods.first{$0.periodCategory == .secondLunch},
                       let secondLunchPeriod = lunchPeriods.first{$0.periodCategory == .secondLunchPeriod} {
                        HStack {
                            VStack {
                                Text("1st Lunch Schedule")
                                    .font(.footnote, weight: .semibold)
                                    .padding(.bottom, 2)
                                    .foregroundColor(.platformSecondaryLabel)
                                    .textAlign(.leading)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)

                                PeriodBlockItem(block: firstLunch,
                                                scheduleTitle: "1st Lunch",
                                                twoLine: true)
                                PeriodBlockItem(block: firstLunchPeriod,
                                                scheduleTitle:  "Period \(firstLunchPeriod.periodNumber ?? -1)",
                                                twoLine: true)
                            }
                            .padding(.trailing, 5)
                            VStack {
                                Text("2nd Lunch Schedule")
                                    .font(.footnote, weight: .semibold)
                                    .padding(.bottom, 2)
                                    .foregroundColor(.platformSecondaryLabel)
                                    .textAlign(.leading)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)

                                PeriodBlockItem(block: secondLunchPeriod,
                                                scheduleTitle: "Period \(secondLunchPeriod.periodNumber ?? -1)",
                                                twoLine: true)
                                PeriodBlockItem(block: secondLunch,
                                                scheduleTitle: "2nd Lunch",
                                                twoLine: true)
                            }
                        }
                       }
                    PeriodBlockSubview(periods: postLunchPeriods)
                    if let period8 = period8,
                       userSettings.isPeriod8On {
                        Divider()
                        Text("Most students don't have period 8, you can turn it off in settings.")
                            .font(.caption)
                            .foregroundColor(.platformSecondaryLabel)
                            .padding(.bottom, 1)
                        PeriodBlockItem(block: period8)
                    }
                }
                .padding(.horizontal, horizontalPadding ? 16 : 0)
            }
        }
        .navigationTitle(scheduleDateDescription)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Analytics.logEvent("tapped_date_item",
                               parameters: ["date": scheduleDay?.date.debugDescription as Any,
                                            "time_stamp": Date().debugDescription,
                                            "time_of_day": formatTime(Date())])
        }

    }

    func formatTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    }
}
