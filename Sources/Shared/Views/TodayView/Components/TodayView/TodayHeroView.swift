//
//  TodayHeroView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 6/3/21.
//

import SFSafeSymbols
import SwiftUI

struct TodayHeroView: View {
    @StateObject var scheduleViewViewModel: SharedScheduleInformation
    @StateObject var todayViewViewModel: TodayViewViewModel
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        ScrollView {
            VStack {
                Picker("", selection: $todayViewViewModel.selectionMode) {
                    Text("1st Lunch")
                        .tag(PeriodCategory.firstLunch)
                    Text("2nd Lunch")
                        .tag(PeriodCategory.secondLunch)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, -10)

//                Label(title: {
//                    Text("InClass™")
//                        .font(.title3)
//                        .fontWeight(.bold)
//                }) {
//                    Image(systemSymbol: .studentdesk)
//                        .foregroundColor(.white)
//                        .padding(3)
//                        .background(Color.primary)
//                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
//                }
//                .padding(.bottom, 2)
//
                ProgressRingView(scheduleDay: scheduleViewViewModel.currentDaySchedule,
                                 selectionMode: $todayViewViewModel.selectionMode)

                if scheduleViewViewModel.currentDaySchedule != nil {
                    Text("Detailed Schedule")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .textAlign(.leading)
                        .padding(.bottom, 10)
                    ScheduleDetailView(scheduleDay: scheduleViewViewModel.currentDaySchedule)
                }
            }
            .padding(EdgeInsets(top: 80, leading: 7, bottom: 0, trailing: 7))
            .padding(.horizontal)
        }
        .background(Color.platformBackground)
        .onboardingModal()
        .onAppear {
            scheduleViewViewModel.objectWillChange.send()
            if !userSettings.developerSettings.shouldCacheData {
                scheduleViewViewModel.reset()
            }
        }
        .aboutFooter()
    }
}
