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
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var userSettings: UserSettings

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
            
            ScheduleView(networkLoadingViewModel: NetworkLoadViewModel(dataReload: scheduleViewViewModel.fetchData),
                         scheduleViewModel: scheduleViewViewModel)
                .tabItem{
                    VStack{
                        Image(systemSymbol: .calendar)
                        Text("Schedule")
                    }
                }
            NewsView()
                .tabItem{
                    VStack{
                        Image(systemSymbol: .newspaperFill)
                        Text("News")
                    }
                }
            SearchView()
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
