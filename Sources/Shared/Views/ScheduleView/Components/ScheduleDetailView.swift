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
import Introspect

struct ScheduleDetailView: View {
    init(scheduleDay: ScheduleDay? = nil,
         horizontalPadding: Bool = true,
         showBackgroundImage: Bool = true,
         respondedSurvey: Bool = false) {
        self.scheduleDay = scheduleDay
        self.horizontalPadding = horizontalPadding
        self.showBackgroundImage = showBackgroundImage

        if showBackgroundImage {
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        }
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    @EnvironmentObject var userSettings: UserSettings
    @State var bottomTextScreenRatio: Double = 0
    @State var enableVisualEffects = true
    
    
    @State var tabBarController: UITabBarController?
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
    @State var hapticsManager = HapticsManager(impactStyle: .light)
    @State private var developerScheduleOn = false


    var body: some View {
        ScrollView {
            ScheduleFallbackSection(userOverrideFallback: $developerScheduleOn,
                                    alternateColored: !showBackgroundImage)

            if shouldFallback {
                ScheduleViewTextLines(scheduleLines: scheduleDay?.scheduleText.lines)
                    .padding(.top, 30)
                    .vibrancyEffectStyle(.label)
                    .vibrancyEffect()

            }
            else {
                if !userSettings.respondedSurvey && showBackgroundImage  {
                    VStack {
                        Text("How do you like the new look?")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        HStack {
                            Button(action: {
                                hapticsManager.notificationImpact(.success)
                                userSettings.respondedSurvey = true
                                Analytics.logEvent("new_UI_like_prod", parameters: [:])
                            }) {
                                Image(systemSymbol: .handThumbsupFill)
                                    .font(.title)
                                    .foregroundColor(.systemGreen)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(BlurEffect().blurEffectStyle(.systemChromeMaterial))
                                    .roundedCorners(cornerRadius: 10)
                                    .padding(.trailing, 10)
                            }

                            Button(action: {
                                hapticsManager.notificationImpact(.success)
                                userSettings.respondedSurvey = true
                                Analytics.logEvent("new_UI_dislike_prod", parameters: [:])
                            }) {
                                Image(systemSymbol: .handThumbsdownFill)
                                    .font(.title)
                                    .foregroundColor(.systemRed)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(BlurEffect().blurEffectStyle(.systemChromeMaterial))
                                    .roundedCorners(cornerRadius: 10)
                                    .padding(.leading, 10)
                            }
                        }
                        .padding(.bottom)
                        .padding(.top, 1)
                        .padding(.horizontal)

                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: 0.33)
                            .padding(.horizontal)
                            .vibrancyEffect()
                    }
                    .padding(.top)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }

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
                                                    twoLine: true,
                                                    isBlurred: showBackgroundImage)
                                    PeriodBlockItem(block: firstLunchPeriod,
                                                    twoLine: true,
                                                    isBlurred: showBackgroundImage)
                                }
                                .padding(.trailing, 5)
                                VStack {
                                    makeLunchTitle(content: "2nd Lunch Times")

                                    PeriodBlockItem(block: secondLunchPeriod,
                                                    twoLine: true,
                                                    isBlurred: showBackgroundImage)
                                    PeriodBlockItem(block: secondLunch,
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
                        Text("Most students don't have period 8. Disable in settings.")
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
//                                    .overlay(
//                                        GeometryReader {geo -> Color in
//                                            DispatchQueue.main.async {
//                                                bottomTextScreenRatio = geo.frame(in: .global).minY / UIScreen.screenHeight
//                                            }
//                                            return Color.clear
//                                        }
//                                    )
                            }, elseThen: {
                                $0
                                    .foregroundColor(.platformSecondaryLabel)
                            })
                                .textAlign(.leading)

                    }

                }
                .padding(.horizontal, horizontalPadding ? 16 : 0)
                .padding(.vertical, showBackgroundImage ? 16: 0)
                    

            }
        }
        .navigationTitle(scheduleDateDescription)
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut, value: userSettings.respondedSurvey)
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
//        .introspectTabBarController {tabController in
//            if !shouldFallback {
//                tabController.tabBar.barStyle = .black
//            }
//            tabBarController = tabController
//        }
//        .onDisappear {
//            tabBarController?.tabBar.barStyle = .default
//        }
        .onDeveloperTap(userSettings) {
            developerScheduleOn.toggle()
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
            .padding(.bottom, -3)
            .padding(.leading)
            .if(showBackgroundImage, transform: {
                $0
                    .vibrancyEffect()
                    .vibrancyEffectStyle(.label)
                    .colorScheme(.dark)
                    .shadow(color: Color.label.opacity(0.85), radius: 1, x: 0, y: 0.8)
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
        ScheduleDetailView(scheduleDay: .sampleScheduleDay,
                           showBackgroundImage: true,
                           respondedSurvey: false)
            .environmentObject(configureSettings())
            .previewDisplayName("Standard")

        NavigationView {
            NavigationLink("Detail") {
                ScheduleDetailView(scheduleDay: .sampleScheduleDay, showBackgroundImage: true)
                    .environmentObject(configureSettings())
            }
        }
        .previewDisplayName("Navigation Stack Push")

        ScheduleDetailView(scheduleDay: .sampleScheduleDay,
                           showBackgroundImage: false)
        .environmentObject(configureSettings(legacySchedule: true))
        .previewDisplayName("White Background Plain")

        ScheduleDetailView(scheduleDay: .sampleScheduleDay, showBackgroundImage: false)
            .environmentObject(configureSettings())
            .previewDisplayName("White Background Formatted")
    }
}
