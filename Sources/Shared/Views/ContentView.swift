//
//  ContentView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI

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
                    Label("Today", systemSymbol: .squareGrid2x2Fill)
                }
            //FIXME: Fix grades API, reload always
            GradesView()
                .tabItem{
                    Label("Grades", systemSymbol: .graduationcapFill)
                    
                }
            ScheduleView(networkLoadingViewModel: networkLoadViewModel,
                         viewModel: sharedScheduleInformation)
                .tabItem{
                    Label("Schedule", systemSymbol: .calendar)
                }
            
            NewsView()
                .tabItem{
                    Label("News", systemSymbol: .newspaperFill)
                }
            SearchView()
                .tabItem {
                    Label("Search", systemSymbol: .magnifyingglass)
                }
            #if DEBUG
            DeveloperSettingsView()
                .tabItem {
                    Label("Settings", systemSymbol: .gearshapeFill)
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
