//
//  ContentView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var sharedScheduleInformation = SharedScheduleInformation()
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.scenePhase) var scenePhase

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
                         scheduleViewModel: sharedScheduleInformation)
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
        .environmentObject(userSettings)
        .accentColor(.appPrimary)
        .overlay(
            VStack {
                if userSettings.developerSettings.developerOn {
                    Text("DEVELOPER MODE")
                        .font(.system(size: 500), weight: .black)
                        .minimumScaleFactor(0.001)
                        .aspectRatio(1, contentMode: .fit)
                        .lineLimit(1)
                        .foregroundColor(.red)
                        .opacity(0.2)
                }
            }
        )
        .onChange(of: scenePhase) { newScenePhase in
              switch newScenePhase {
              case .active:
                sharedScheduleInformation.objectWillChange.send()
                let activeCount = UserDefaults.standard.integer(forKey: "activeSceneCount")
                UserDefaults.standard.set(activeCount+1, forKey:"activeSceneCount")
              case .inactive:
                ()
              case .background:
                AppVersionStatus.setCurrentVersionStatus()
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
