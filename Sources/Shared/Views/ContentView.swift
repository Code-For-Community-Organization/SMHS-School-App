//
//  ContentView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI
import AlertKit

struct ContentView: View {
    @StateObject var sharedScheduleInformation = SharedScheduleInformation()
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        TabView {
            let networkLoadViewModel = NetworkLoadViewModel(dataReload: sharedScheduleInformation.fetchData)
            TodayView(networkLoadViewModel: networkLoadViewModel,
                      scheduleViewViewModel: sharedScheduleInformation)
                .tabItem{
                    VStack{
                        Image(systemSymbol: .squareGrid2x2Fill)
                        Text("Today")
                    }
                }
            
            ScheduleView(networkLoadingViewModel: networkLoadViewModel,
                         scheduleViewModel: sharedScheduleInformation)
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
                sharedScheduleInformation.objectWillChange.send()
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
