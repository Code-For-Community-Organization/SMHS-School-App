//
//  ContentView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI
import AlertKit

struct ContentView: View {
    @StateObject var scheduleViewViewModel = SharedScheduleInformation()
    @StateObject var alertManager = AlertManager()
    @StateObject var newsViewViewModel = NewsViewViewModel()
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var userSettings: UserSettings
    @AppStorage("didShowGradAlert") var didShowGradAlert = false

    var body: some View {
        TabView {
            TodayView(networkLoadViewModel: NetworkLoadViewModel(dataReload: scheduleViewViewModel.fetchData),
                      scheduleViewViewModel: scheduleViewViewModel)
                .tabItem{
                    VStack{
                        Image(systemSymbol: .squareGrid2x2Fill)
                        Text("Today")
                    }
                }
                .onAppear {
                    if !didShowGradAlert {
                        alertManager.show(dismiss: .info(title: "Congratulations!", message: "Congradulations to graduating the Class of 2021.",
                                                         dismissButton: .cancel(Text("Don't Show Again"))))
                        didShowGradAlert.toggle()
                    }
                }
            
            ScheduleView(networkLoadingViewModel: NetworkLoadViewModel(dataReload: scheduleViewViewModel.fetchData),
                         scheduleViewModel: scheduleViewViewModel)
                .tabItem{
                    VStack{
                        Image(systemSymbol: .calendar)
                        Text("Schedule")
                    }
                }
            NewsView(newsViewViewModel: newsViewViewModel)
                .tabItem{
                    VStack{
                        Image(systemSymbol: .newspaperFill)
                        Text("News")
                    }
                }
            SearchView(scheduleViewModel: scheduleViewViewModel, newsViewViewModel: newsViewViewModel)
                .tabItem {
                    Label("Search", systemSymbol: .magnifyingglass)
                }
            #if DEBUG
            DeveloperSettingsView()
                .tabItem {
                    VStack {
                        Image(systemSymbol: .gearshapeFill)
                        Text("Settings")
                    }
                }
            #endif
        }
        .onboardingModal()
        .environmentObject(UserSettings())
        .accentColor(Color.primary)
        .onChange(of: scenePhase) { newScenePhase in
              switch newScenePhase {
              case .active:
                scheduleViewViewModel.objectWillChange.send()
                let activeCount = UserDefaults.standard.integer(forKey: "activeSceneCount")
                UserDefaults.standard.set(activeCount+1, forKey:"activeSceneCount")
              case .inactive:
                ()
              case .background:
                OnboardingWrapperViewModel.setCurrentVersionStatus()
              @unknown default:
                ()
              }
            }
        .uses(alertManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
