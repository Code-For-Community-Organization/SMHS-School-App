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

struct ScheduleDetailView: View {
    @EnvironmentObject var userSettings: UserSettings
    @State var bottomTextScreenRatio: Double = 0
    @State var enableVisualEffects = true

    var gradientTopLocation: CGFloat {
        print("Top: \(bottomTextScreenRatio - 0.05.clamped(to: 0...1))")
        return bottomTextScreenRatio - 0.05.clamped(to: 0...1)
    }

    var gradientBottomLocation: CGFloat {
        print("bottom: \(bottomTextScreenRatio + 0.05.clamped(to: 0...1))")
        return bottomTextScreenRatio + 0.05.clamped(to: 0...1)
    }

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
        return scheduleDay?.periods.isEmpty ?? true
    }

    var horizontalPadding = true
    var showBackgroundImage = true

    @State private var developerScheduleOn = false

    var body: some View {
        ScrollView {
            if userSettings.preferLegacySchedule ||
                developerScheduleOn ||
                shouldFallback {
                ScheduleViewTextLines(scheduleLines: scheduleDay?.scheduleText.lines)
            }
            else {
                ZStack {
                    VStack(spacing: 10) {
                        PeriodBlockSubview(periods: preLunchPeriods)

                        if let firstLunch = lunchPeriods.first{$0.periodCategory == .firstLunch},
                        let firstLunchPeriod = lunchPeriods.first{$0.periodCategory == .firstLunchPeriod},
                            let secondLunch = lunchPeriods.first{$0.periodCategory == .secondLunch},
                            let secondLunchPeriod = lunchPeriods.first{$0.periodCategory == .secondLunchPeriod} {
                                HStack {
                                    VStack {
                                        makeLunchTitle(content: "1st Lunch Times")
                                        PeriodBlockItem(block: firstLunch,
                                                        scheduleTitle: "1st Lunch",
                                                        twoLine: true)
                                        PeriodBlockItem(block: firstLunchPeriod,
                                                        scheduleTitle:  "Period \(firstLunchPeriod.periodNumber ?? -1)",
                                                        twoLine: true)
                                    }
                                    .padding(.trailing, 5)
                                    VStack {
                                        makeLunchTitle(content: "2nd Lunch Times")
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
                        if let atheleticsInfo = scheduleDay?.atheleticsInfo {
                            Text(atheleticsInfo)
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
                        }

                    }
                    .padding(.horizontal, horizontalPadding ? 16 : 0)

                }
            }
        }
        .navigationTitle(scheduleDateDescription)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(false)
        .background (
            GeometryReader {geo in
                ZStack {
                    Image("SM-Field-HiRes")
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(1.4, anchor: .bottom)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .blur(radius: 3, opaque: true)

                        .saturation(0.6)

                    Image("SM-Field-HiRes")
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(1.4, anchor: .bottom)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .saturation(0.6)
                        .blur(radius: 60, opaque: true)
                        .mask (
                            LinearGradient(stops: [.init(color: .clear, location: 0),
                                                   .init(color: .clear, location: gradientTopLocation),
                                                   .init(color: .black, location: gradientBottomLocation),
                                                  .init(color: .black, location: 1)], startPoint: .top, endPoint: .bottom)
                        )



                }

            }
            .drawingGroup()
            .edgesIgnoringSafeArea(.all)
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
            .shadow(color: Color.black.opacity(0.85), radius: 1, x: 0, y: 0.8)
            .foregroundColor(Color.white)
            .textAlign(.leading)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
    }
}

struct ScheduleDetailView_Previews: PreviewProvider {
    static var settings: UserSettings = {
        let settings = UserSettings()
        settings.editableSettings = [.init(periodNumber: 6, textContent: "AP Calculus BC")]
        return settings
    }()

    static var previews: some View {
        ScheduleDetailView(scheduleDay: .sampleScheduleDay)
            .environmentObject(settings)
    }
}
