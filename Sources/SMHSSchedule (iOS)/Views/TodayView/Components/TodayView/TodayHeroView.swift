//
//  TodayHeroView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 6/3/21.
//

import SwiftUI

struct TodayHeroView: View {
    @StateObject var scheduleViewViewModel: ScheduleViewModel
    @StateObject var todayViewViewModel: TodayViewViewModel
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        ScrollView {
            VStack {
                Picker("", selection: $todayViewViewModel.selectionMode){
                    Text("1st Lunch")
                        .tag(PeriodCategory.firstLunch)
                    Text("2nd Lunch")
                        .tag(PeriodCategory.secondLunch)
                    
                }
                .pickerStyle(SegmentedPickerStyle())
                ProgressRingView(scheduleDay: scheduleViewViewModel.currentDaySchedule, selectionMode: $todayViewViewModel.selectionMode)
                    .padding(.vertical, 10)
                if scheduleViewViewModel.currentDaySchedule != nil {
                    Text("Detailed Schedule")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .textAlign(.leading)
                        .padding(.bottom, 10)
                    ScheduleDetailView(scheduleDay: scheduleViewViewModel.currentDaySchedule)
                }
            }
            .padding(EdgeInsets(top: 110, leading: 7, bottom: 0, trailing: 7))
            .padding(.horizontal)
        }
        .background(Color.platformBackground)
        .onboardingModal()
        .onAppear{
            scheduleViewViewModel.objectWillChange.send()
            if !userSettings.developerSettings.shouldCacheData {
                scheduleViewViewModel.reset()
            }
        }
        .aboutFooter()
    }
}
