//
//  MasterCalendarView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/4/21.
//

import SwiftUI
import ElegantCalendar
import FirebaseAnalytics

struct MasterCalendarView: View {
    @State private var orientationValue: Int?
    @State private var hapticsManager = HapticsManager(impactStyle: .light)
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @StateObject private var calendarManager = ElegantCalendarManager(
        configuration: CalendarConfiguration(startDate: startDate(),
                                             endDate: endDate()),
        initialMonth: Date())
    @ObservedObject private var calendarViewModel: MasterCalendarViewModel
    init(calendarViewModel: MasterCalendarViewModel) {
        self.calendarViewModel = calendarViewModel
    }
    var body: some View {
        ZStack(alignment: .bottom) {
            ElegantCalendarView(calendarManager: calendarManager)
                .theme(.init(primary: appPrimary))
            Button(action: {
                hapticsManager.UIFeedbackImpact()
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemSymbol: .xmark)
                    .foregroundColor(Color.platformSecondaryLabel)
                    .padding(10)
                    .background(Color.platformSecondaryBackground)
                    .clipShape(Circle())
            })
            .padding(.bottom, 30)
        }
        .onAppear {
            Analytics.logEvent("opened_calendar", parameters: nil)
            calendarManager.datasource = self
            calendarManager.delegate = self
            DispatchQueue.main.async {
                calendarManager.datasource = self
                //AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                orientationValue = UIDevice.current.orientation.rawValue
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
            }
        }
        .onDisappear {
            DispatchQueue.main.async {
                    //AppDelegate.orientationLock = UIInterfaceOrientationMask.all
                    UIDevice.current.setValue(orientationValue, forKey: "orientation")
                    UINavigationController.attemptRotationToDeviceOrientation()
            }
        }
    }
    
    private static func startDate() -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.month = 1
        components.day = 1
        return Calendar.current.date(from: components)!
    }
    
    private static func endDate() -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.year = components.year?.advanced(by: 1)
        components.month = 1
        components.day = 1
        return Calendar.current.date(from: components)!
    }
}

extension MasterCalendarView: ElegantCalendarDataSource {
    func calendar(backgroundColorOpacityForDate date: Date) -> Double {
        calendarViewModel.calendarManager.getOpacity(forDay: date)
    }

    func calendar(canSelectDate date: Date) -> Bool {true}

    func calendar(viewForSelectedDate date: Date, dimensions size: CGSize) -> AnyView
    {
        SelectedDateView(events: calendarViewModel.calendarManager.days[date]?.events ?? [])
            .typeErased()
    }
}

extension MasterCalendarView: ElegantCalendarDelegate {
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    func formatMonth(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMN"
        return dateFormatter.string(from: date)
    }
    
    func calendar(didSelectDay date: Date) {
        
        Analytics.logEvent("selected_calendar_day",
                           parameters: ["selected_date": formatDate(date)])
    }
    
    func calendar(willDisplayMonth date: Date) {
        Analytics.logEvent("swiped_calendar_month",
                           parameters: ["display_month": formatMonth(date)])
    }
}
