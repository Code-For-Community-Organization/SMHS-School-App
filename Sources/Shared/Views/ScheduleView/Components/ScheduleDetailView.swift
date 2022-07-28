//
//  ScheduleCardView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI
import SFSafeSymbols
import FirebaseAnalytics
import SwiftUIX
import SwiftUIVisualEffects

struct ScheduleDetailView: View {
    init(scheduleDay: ScheduleDay? = nil,
         horizontalPadding: Bool = true,
         showBackgroundImage: Bool = true) {
        self.scheduleDay = scheduleDay
        self.horizontalPadding = horizontalPadding
        self.showBackgroundImage = showBackgroundImage
        if showBackgroundImage {
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        }
    }

    @EnvironmentObject var userSettings: UserSettings
    @State var bottomTextScreenRatio: Double = 0
    @State var enableVisualEffects = true

    

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

    var shouldFallback: Bool {
        return userSettings.preferLegacySchedule ||
        developerScheduleOn ||
        scheduleDay?.periods.isEmpty ?? true
    }

    var horizontalPadding = true
    var showBackgroundImage = true

    @State private var developerScheduleOn = false

    var body: some View {
        ScrollView {
            if shouldFallback {
                ScheduleViewTextLines(scheduleLines: scheduleDay?.scheduleText.lines)
                    .padding(.top, 30)
                    .vibrancyEffectStyle(.label)
                    .vibrancyEffect()
            }
            else {
                ZStack {
                    VStack(spacing: 10) {
                        ForEach(preLunchPeriods, id: \.self){period in
                            PeriodBlockItem(block: period, isBlurred: showBackgroundImage)
                        }

                        if let firstLunch = lunchPeriods.first{$0.periodCategory == .firstLunch},
                        let firstLunchPeriod = lunchPeriods.first{$0.periodCategory == .firstLunchPeriod},
                            let secondLunch = lunchPeriods.first{$0.periodCategory == .secondLunch},
                            let secondLunchPeriod = lunchPeriods.first{$0.periodCategory == .secondLunchPeriod} {
                                HStack {
                                    VStack {
                                        makeLunchTitle(content: "1st Lunch Times")
                                        PeriodBlockItem(block: firstLunch,
                                                        scheduleTitle: "1st Lunch",
                                                        twoLine: true,
                                                        isBlurred: showBackgroundImage)
                                        PeriodBlockItem(block: firstLunchPeriod,
                                                        scheduleTitle:  "Period \(firstLunchPeriod.periodNumber ?? -1)",
                                                        twoLine: true,
                                                        isBlurred: showBackgroundImage)
                                    }
                                    .padding(.trailing, 5)
                                    VStack {
                                        makeLunchTitle(content: "2nd Lunch Times")
                                        PeriodBlockItem(block: secondLunchPeriod,
                                                        scheduleTitle: "Period \(secondLunchPeriod.periodNumber ?? -1)",
                                                        twoLine: true,
                                                        isBlurred: showBackgroundImage)
                                        PeriodBlockItem(block: secondLunch,
                                                        scheduleTitle: "2nd Lunch",
                                                        twoLine: true,
                                                        isBlurred: showBackgroundImage)
                                    }
                                }
                            }

                        ForEach(postLunchPeriods, id: \.self){period in
                            PeriodBlockItem(block: period,
                                            isBlurred: showBackgroundImage)
                        }

                        if let period8 = period8,
                           userSettings.isPeriod8On {
                            Divider()
                                .if(showBackgroundImage) {
                                    $0
                                        .overlay(Color.white)
                                }
                            Text("Most students don't have period 8, you can turn it off in settings.")
                                .font(.caption)
                                .if(showBackgroundImage, transform: {
                                    $0
                                        .vibrancyEffect()
                                        .vibrancyEffectStyle(.label)
                                        .colorScheme(.dark)

                                }, elseThen: {
                                    $0
                                        .foregroundColor(.platformSecondaryLabel)
                                })
                                    .padding(.bottom, 1)

                                    PeriodBlockItem(block: period8, isBlurred: showBackgroundImage)
                        }
                        if let atheleticsInfo = scheduleDay?.atheleticsInfo {
                            Text(atheleticsInfo)
                                .if(showBackgroundImage, transform: {
                                    $0
                                        .vibrancyEffect()
                                        .vibrancyEffectStyle(.label)
                                        .colorScheme(.dark)
                                        .overlay(
                                            GeometryReader {geo -> Color in
                                                DispatchQueue.main.async {
                                                    bottomTextScreenRatio = geo.frame(in: .global).minY / UIScreen.screenHeight
                                                }
                                                return Color.clear
                                            }
                                        )
                                }, elseThen: {
                                    $0
                                        .foregroundColor(.platformSecondaryLabel)
                                })
                        }

                    }
                    .padding(.horizontal, horizontalPadding ? 16 : 0)

                }
            }
        }
        .navigationTitle(scheduleDateDescription)
        .navigationBarTitleDisplayMode(.inline)
        .if(showBackgroundImage) {
            $0
                .navigationBarHidden(false)
        }
        .background (
            ZStack {
                // 3 cases of background:
                // 1. Used in TodayView, no background (white)
                // 2. Used in normal schedule, animated dynamic blur background
                // 3. Used in fallback text-only, static blur background
                if showBackgroundImage {
                    AnimatedBlurBackground(bottomTextScreenRatio: $bottomTextScreenRatio,
                                           dynamicBlurred: !shouldFallback)
                }
            }
        )

        .onAppear {
            Analytics.logEvent("tapped_date_item",
                               parameters: ["date": scheduleDay?.date.debugDescription as Any,
                                            "time_stamp": Date().debugDescription,
                                            "time_of_day": formatTime(Date())])

        }
        
        .onDeveloperTap(userSettings) {
            if userSettings.developerSettings.developerOn {
                developerScheduleOn.toggle()
            }
        }


    }

    func formatTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    }

    func makeLunchTitle(content: String) -> some View {
        Text(content)
            .font(.footnote)
            .fontWeight(.bold)
            .padding(.bottom, 2)
            .if(showBackgroundImage, transform: {
                $0
                    .vibrancyEffect()
                    .vibrancyEffectStyle(.label)
                    .colorScheme(.dark)
                    .shadow(color: Color.black.opacity(0.85), radius: 1, x: 0, y: 0.8)
            }, elseThen: {
                $0
                    .foregroundColor(.platformSecondaryLabel)

            })
            .textAlign(.leading)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
    }
}

struct ScheduleDetailView_Previews: PreviewProvider {
    static func configureSettings(legacySchedule: Bool = false) -> UserSettings {
        let settings = UserSettings()
        settings.preferLegacySchedule = legacySchedule
        settings.editableSettings = [.init(periodNumber: 6, textContent: "AP Calculus BC")]
        return settings
    }

    static var previews: some View {
        ScheduleDetailView(scheduleDay: .sampleScheduleDay, showBackgroundImage: true)
            .environmentObject(configureSettings())
        ScheduleDetailView(scheduleDay: .sampleScheduleDay,
                           showBackgroundImage: false)
        .environmentObject(configureSettings(legacySchedule: true))
        ScheduleDetailView(scheduleDay: .sampleScheduleDay, showBackgroundImage: false)
            .environmentObject(configureSettings())
    }
}
