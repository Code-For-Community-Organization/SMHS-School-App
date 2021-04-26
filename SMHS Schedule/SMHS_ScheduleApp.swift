//
//  SMHS_ScheduleApp.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI

@main
struct SMHS_ScheduleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear{
                    print("ContentView Appear")
                }
        }
    }
}
