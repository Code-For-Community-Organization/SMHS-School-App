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

    var shouldShowTeams: Bool {
        // Get cloud config value for whether should show
        // Only show if user did not already
        // join teams from onboarding prompt
        return Constants.shouldShowJoinTeamsBanner && !userSettings.didJoinTeams
    }

    var body: some View {
        ScrollView {
            VStack {
                if let url = Constants.joinTeamsURL,
                   shouldShowTeams {
                    TeamsJoinBanner(showBanner: $todayViewViewModel.showTeamsBanner, action: {
                            openURL(url)

                        })
                        .onAppear {
                            todayViewViewModel.showTeamsBanner = true
                        }
                        .padding(.bottom, 5)
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
                        ScheduleDetailView(scheduleDay: scheduleViewViewModel.currentDaySchedule,
                                           horizontalPadding: false)
                    }
                    Text("Detailed Schedule")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .textAlign(.leading)
                        .padding(.bottom, 10)
                    ScheduleDetailView(scheduleDay: .sampleScheduleDay,
                                       horizontalPadding: false,
                                       showBackgroundImage: false)
                    
                    AnnoucementBanner(viewModel: todayViewViewModel)

                }
                .padding(.horizontal)
            }
            .padding(.top, (shouldShowTeams && todayViewViewModel.showTeamsBanner) ? 54 : 80)

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
            .animation(.easeInOut, value: todayViewViewModel.loadingAnnoucements)
        })
    }
}

struct TodayHeroView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView(networkLoadViewModel: NetworkLoadViewModel(dataReload: {_,_,_ in}), scheduleViewViewModel: .mockScheduleView, todayViewViewModel: .mockViewModel)
            .environmentObject(UserSettings())
    }
}
