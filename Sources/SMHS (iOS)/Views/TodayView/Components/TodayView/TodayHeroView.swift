//
//  TodayHeroView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 6/3/21.
//

import SwiftUI
import SFSafeSymbols

struct TodayHeroView: View {
    @StateObject var scheduleViewViewModel: SharedScheduleInformation
    @StateObject var todayViewViewModel: TodayViewViewModel
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.openURL) var openURL

    var body: some View {
        ScrollView {
            VStack {
                if let url = todayViewViewModel.getJoinTeamsURL(),
                   todayViewViewModel.shouldShowTeams {
                    TeamsJoinBanner(showBanner: $todayViewViewModel.showTeamsBanner, action: {
                            openURL(url)

                        })
                        .onAppear {
                            todayViewViewModel.showTeamsBanner = true
                        }
                }

                VStack {
                    Picker("", selection: $todayViewViewModel.selectionMode){
                        Text("1st Lunch")
                            .tag(PeriodCategory.firstLunch)
                        Text("2nd Lunch")
                            .tag(PeriodCategory.secondLunch)

                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.top, -10)

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

                    AnnoucementBanner(viewModel: todayViewViewModel)

                }
                .padding(.horizontal, 23)
            }
            .padding(.top, todayViewViewModel.showTeamsBanner ? 54 : 80)

        }
        .background(Color.platformBackground)
        .onboardingModal()
        .onAppear{
            todayViewViewModel.updateAnnoucements()
            scheduleViewViewModel.objectWillChange.send()
            if !userSettings.developerSettings.shouldCacheData {
                scheduleViewViewModel.reset()
            }
        }
        .aboutFooter()
        .sheet(isPresented: $todayViewViewModel.showAnnoucement,
               content: {
            VStack {
                if let html = todayViewViewModel.todayAnnoucementHTML {
                    WKWebViewRepresentable(HTMLString: html)
                }

            }
        })
    }
}

struct TodayHeroView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView(networkLoadViewModel: NetworkLoadViewModel(dataReload: {_ in}), scheduleViewViewModel: .mockScheduleView, todayViewViewModel: .mockViewModel)
            .environmentObject(UserSettings())
    }
}
