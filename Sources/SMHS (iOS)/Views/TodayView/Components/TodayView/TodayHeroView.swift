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
    
    @State var selected: Banner?
    @State var banners: [Banner] = []
    @Namespace var animate
    
    var shouldShowTeams: Bool {
        // Get cloud config value for whether should show
        // Only show if user did not already
        // join teams from onboarding prompt
        return Constants.shouldShowJoinTeamsBanner && !userSettings.didJoinTeams
    }
    
    var body: some View {
        ZStack {
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
                            
                            ScheduleDetailView(scheduleDay: scheduleViewViewModel.currentDaySchedule,
                                               horizontalPadding: false,
                                               showBackgroundImage: false)
                        }
                    }
                    .padding(.top, (shouldShowTeams && todayViewViewModel.showTeamsBanner) ? 54 : 80)
                    .padding(.horizontal)

                    if Constants.showForYou && !banners.isEmpty {
                        Group {
                            Text("For You")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .textAlign(.leading)
                                .padding(.horizontal)

                            Divider()
                                .padding(.bottom, 15)
                                .padding(.horizontal)

                            BannersView(banners: $banners, selected: $selected, animate: animate)
                        }
                        .transition(.opacity)


                    }

                    AnnoucementBanner(viewModel: todayViewViewModel)
                                                .padding(.horizontal)

                }
                .background(Color.platformBackground)
                .onboardingModal()
                .aboutFooter()
                .onChange(of: selected, perform: { val in
                    if val != nil {
                        withAnimation {
                            todayViewViewModel.showToolbar = false
                        }
                    }
                    else {
                        withAnimation {
                            todayViewViewModel.showToolbar = true
                        }
                    }
                })
                .sheet(isPresented: $todayViewViewModel.showAnnoucement,
                       content: {
                    VStack {
                        if let html = todayViewViewModel.todayAnnoucementHTML {
                            WKWebViewRepresentable(HTMLString: html)
                        }
                        
                    }
                    .animation(.easeInOut, value: todayViewViewModel.loadingAnnoucements)
                })
                .opacity(selected != nil ? 0 : 1)
                
                if let selected = selected {
                    BannerDetailView(banner: selected, selected: $selected, animate: animate)
                    // sync animate
                }
            }
            .onAppear {
                todayViewViewModel.updateAnnoucements()
                scheduleViewViewModel.objectWillChange.send()
                if !userSettings.developerSettings.shouldCacheData {
                    scheduleViewViewModel.reset()
                }
                
                Task {
                    do {
                        self.banners = try await Banner.fetch()
                    }
                    catch {
                        print("Error fetching banners: \(error)")
                        self.banners = []
                    }
                }
            }
        }
    }
}

struct TodayHeroView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView(networkLoadViewModel: NetworkLoadViewModel(dataReload: {_,_,_ in}), scheduleViewViewModel: .mockScheduleView, todayViewViewModel: .mockViewModel)
            .environmentObject(UserSettings())
    }
}
