//
//  ContentView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ScheduleView()
                .tabItem{
                    VStack{
                        Image(systemSymbol: .calendar)
                        Text("Schedule")
                    }
                }

            TodayView()
                .tabItem{
                    VStack{
                        Image(systemSymbol: .squareGrid2x2Fill)
                        Text("Today")
                    }
                }
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemSymbol: .gearshapeFill)
                        Text("Settings")
                    }
                }
        }
        .accentColor(Color.primary)
        .environmentObject(UserSettings())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
