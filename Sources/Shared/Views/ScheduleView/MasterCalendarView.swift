//
//  MasterCalendarView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/4/21.
//

import SwiftUI
import ElegantCalendar

struct MasterCalendarView: View {
    // Start & End date should be configured based on your needs.
    //static let startDate = Calendar.current.date(bySetting: .month, value: 1, of: Date())!
    //static let endDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
    @State var hapticsManager = HapticsManager(impactStyle: .light)
    @Binding var showCalendar: Bool
    @ObservedObject var calendarManager = ElegantCalendarManager(
        configuration: CalendarConfiguration(startDate: startDate(),
                                             endDate: endDate()),
        initialMonth: Date())
    var body: some View {
        ZStack(alignment: .bottom) {
            ElegantCalendarView(calendarManager: calendarManager)
                .theme(.init(primary: .primary))
            Button(action: {
                hapticsManager.UIFeedbackImpact()
                showCalendar = false
            }, label: {
                Image(systemSymbol: .xmark)
                    .foregroundColor(Color.platformSecondaryLabel)
                    .padding(20)
                    .background(Color.platformSecondaryBackground)
                    .clipShape(Circle())
            })
            .padding(.bottom, 30)
        }
        .onAppear {
            DispatchQueue.main.async {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
            }
        }
        .onDisappear {
            DispatchQueue.main.async {
                    AppDelegate.orientationLock = UIInterfaceOrientationMask.all
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                    UINavigationController.attemptRotationToDeviceOrientation()
            }
        }
    }
    
    static func startDate() -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.month = 1
        components.day = 1
        return Calendar.current.date(from: components)!
    }
    
    static func endDate() -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.year = components.year?.advanced(by: 1)
        components.month = 1
        components.day = 1
        return Calendar.current.date(from: components)!
    }
}

extension MasterCalendarView: ElegantCalendarDataSource {
    
}
