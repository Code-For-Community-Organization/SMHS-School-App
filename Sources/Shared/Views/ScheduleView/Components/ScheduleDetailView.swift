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
import Introspect

struct ScheduleDetailView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    init(scheduleDay: ScheduleDay? = nil,
         horizontalPadding: Bool = true,
         showBackgroundImage: Bool = true,
         respondedSurvey: Bool = false,
         disableScroll: Bool = false) {
        self.scheduleDay = scheduleDay
        self.horizontalPadding = horizontalPadding
        self.showBackgroundImage = showBackgroundImage
        self.disableScroll = disableScroll

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
        let periods = scheduleDay?.periods ?? []
        let firstIndex = periods.firstIndex{$0.periodCategory.isLunchRevolving}
        if let firstIndex = firstIndex {
            return Array(periods[0..<firstIndex])
        }
        let removingPeriod8 = periods.filter({$0.periodNumber != 8})
        
        return removingPeriod8 //Fallback on all periods, assuming no lunch or single lunch
    }
    
    //1st or 2nd lunch revolving periods, 2nd out of 3 UI sections
    var lunchPeriods: LunchBlock? {
        let periods = scheduleDay?.periods ?? []
        let firstIndex = scheduleDay?.periods.firstIndex{$0.periodCategory.isLunchRevolving}
        let lastIndex = scheduleDay?.periods.lastIndex{$0.periodCategory.isLunchRevolving} //Last instance 1st/2nd nutrition block
        if let firstIndex = firstIndex,
           let lastIndex = lastIndex {
            let lunchPeriods = Array(periods[firstIndex...lastIndex])
            return LunchBlock(from: lunchPeriods)
        }
        return nil
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
        scheduleDay?.scheduleText.contains(Constants.fallbackIdentifier) ?? false ||
        scheduleDay?.periods.isEmpty ?? true
    }
    
    var horizontalPadding: Bool
    var showBackgroundImage: Bool
    var disableScroll: Bool
    @State var hapticsManager = HapticsManager(impactStyle: .light)
    @State private var developerScheduleOn = false


    var body: some View {
        ScrollView {
            // Don't show revert button if it's already
            // falled back to plain text schedule
            if !(scheduleDay?.periods.isEmpty ?? true) {
                ScheduleFallbackSection(userOverrideFallback: $developerScheduleOn,
                                        alternateColored: !showBackgroundImage)
            }

            if shouldFallback {
                ScheduleViewTextLines(scheduleLines: scheduleDay?.scheduleText.lines)
                    .padding(.top, 30)
                    .foregroundColor(.platformBackground)

            }
            else {
//                if !userSettings.respondedSurvey && showBackgroundImage  {
//                    VStack {
//                        Text("How do you like the new look?")
//                            .font(.title3)
//                            .fontWeight(.bold)
//                            .foregroundColor(.white)
//
//                        HStack {
//                            Button(action: {
//                                hapticsManager.notificationImpact(.success)
//                                userSettings.respondedSurvey = true
//                                Analytics.logEvent("new_UI_like_prod", parameters: [:])
//                            }) {
//                                Image(systemSymbol: .handThumbsupFill)
//                                    .font(.title)
//                                    .foregroundColor(.systemGreen)
//                                    .padding(.vertical, 10)
//                                    .frame(maxWidth: .infinity)
//                                    .background(BlurEffect().blurEffectStyle(.systemChromeMaterial))
//                                    .roundedCorners(cornerRadius: 10)
//                                    .padding(.trailing, 10)
//                            }
//
//                            Button(action: {
//                                hapticsManager.notificationImpact(.success)
//                                userSettings.respondedSurvey = true
//                                Analytics.logEvent("new_UI_dislike_prod", parameters: [:])
//                            }) {
//                                Image(systemSymbol: .handThumbsdownFill)
//                                    .font(.title)
//                                    .foregroundColor(.systemRed)
//                                    .padding(.vertical, 10)
//                                    .frame(maxWidth: .infinity)
//                                    .background(BlurEffect().blurEffectStyle(.systemChromeMaterial))
//                                    .roundedCorners(cornerRadius: 10)
//                                    .padding(.leading, 10)
//                            }
//                        }
//                        .padding(.bottom)
//                        .padding(.top, 1)
//                        .padding(.horizontal)
//
//                        Rectangle()
//                            .frame(maxWidth: .infinity, maxHeight: 0.33)
//                            .padding(.horizontal)
//                            .vibrancyEffect()
//                    }
//                    .padding(.top)
//                    .transition(.move(edge: .top).combined(with: .opacity))
//                }

                VStack(spacing: 10) {
                    ForEach(preLunchPeriods, id: \.self){period in
                        PeriodBlockItem(block: period, isBlurred: showBackgroundImage)
                    }

                    if let lunchPeriods = lunchPeriods {
                        HStack {
                            VStack {
                                // Force unwrap - shouldFallBack should catch nil
                                let firstLunch = lunchPeriods.firstLunch
                                makeLunchTitle(content: "1st Lunch Times")
                                PeriodBlockItem(block: firstLunch.lunchPeriod,
                                                twoLine: true,
                                                isBlurred: showBackgroundImage)
                                PeriodBlockItem(block: firstLunch.revolvingPeriod,
                                                twoLine: true,
                                                isBlurred: showBackgroundImage)
                            }
                            .padding(.trailing, 5)
                            VStack {
                                let secondLunch = lunchPeriods.secondLunch
                                makeLunchTitle(content: "2nd Lunch Times")
                                PeriodBlockItem(block: secondLunch.revolvingPeriod,
                                                twoLine: true,
                                                isBlurred: showBackgroundImage)
                                PeriodBlockItem(block: secondLunch.lunchPeriod,
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

                        Text("For some students only. Disable in settings.")
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
                                .textSelection(.enabled)

                    }

                }
                .padding(.horizontal, horizontalPadding ? 16 : 0)
                .padding(.bottom, showBackgroundImage ? 16: 0)
                    

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
        .scrollDisabled(disableScroll)
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
                    .if(colorScheme == .light) {view in
                        view
                            .shadow(color: Color.label.opacity(0.85), radius: 1, x: 0, y: 0.8)

                    }
            }, elseThen: {
                $0
                    .foregroundColor(.platformSecondaryLabel)
                
            })
                .textAlign(.leading)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
    }

    struct LunchBlock {
        struct Lunch {
            var revolvingPeriod: ClassPeriod
            var lunchPeriod: ClassPeriod
        }
        var firstLunch: Lunch
        var secondLunch: Lunch

        init?(from lunchPeriods: [ClassPeriod]) {
            if let firstLunch = lunchPeriods.first(where: {$0.periodCategory == .firstLunch}),
               let firstLunchPeriod = lunchPeriods.first(where: {$0.periodCategory == .firstLunchPeriod}),
               let secondLunch = lunchPeriods.first(where: {$0.periodCategory == .secondLunch}),
               let secondLunchPeriod = lunchPeriods.first(where: {$0.periodCategory == .secondLunchPeriod}) {
                        self.firstLunch = Lunch(revolvingPeriod: firstLunchPeriod,
                                           lunchPeriod: firstLunch)
                        self.secondLunch = Lunch(revolvingPeriod: secondLunchPeriod,
                                            lunchPeriod: secondLunch)
                    }
            else {
                return nil
            }
        }
    }
}

struct ScheduleDetailView_Previews: PreviewProvider {
    static func configureSettings(legacySchedule: Bool = false) -> UserSettings {
        let settings = UserSettings()
        settings.preferLegacySchedule = legacySchedule
        //settings.editableSettings = [.init(periodNumber: 6, subject: "AP Calculus BC", room: .g301)]
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

        ScheduleDetailView(scheduleDay: .sampleScheduleDay,
                           showBackgroundImage: true)
        .environmentObject(configureSettings(legacySchedule: true))

        ScheduleDetailView(scheduleDay: .sampleScheduleDay, showBackgroundImage: false)
            .environmentObject(configureSettings())
            .previewDisplayName("White Background Formatted")
    }
}
