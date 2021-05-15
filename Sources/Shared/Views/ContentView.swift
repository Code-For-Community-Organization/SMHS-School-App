//
//  ContentView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var scheduleViewViewModel = ScheduleViewModel()
    @StateObject var newsViewViewModel = NewsViewViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        TabView {
            TodayView(scheduleViewViewModel: scheduleViewViewModel)
                .tabItem{
                    VStack{
                        Image(systemSymbol: .squareGrid2x2Fill)
                        Text("Today")
                    }
                }
            
            ScheduleView(scheduleViewModel: scheduleViewViewModel)
                .tabItem{
                    VStack{
                        Image(systemSymbol: .calendar)
                        Text("Schedule")
                    }
                }
            NewsView(newsViewViewModel: newsViewViewModel, scheduleViewModel: scheduleViewViewModel)
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
              case .inactive:
                ()
              case .background:
                ()
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
