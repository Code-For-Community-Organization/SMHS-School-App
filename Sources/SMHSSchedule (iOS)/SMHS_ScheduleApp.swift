//
//  SMHS_ScheduleApp.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI
import StoreKit

@main
struct SMHS_ScheduleApp: App {
    init() {
        // get current number of times app has been launched (https://stackoverflow.com/questions/31966810/count-number-of-times-app-has-been-launched-using-swift)
        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
        let activeSceneCount = UserDefaults.standard.integer(forKey: "activeSceneCount")
        // increment received number by one
        UserDefaults.standard.set(currentCount+1, forKey:"launchCount")
        if currentCount > 8 ||
            activeSceneCount > 20 {
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                SKStoreReviewController.requestReview()
                UserDefaults.standard.setValue(0, forKey: "launchCount")
                UserDefaults.standard.setValue(0, forKey: "activeSceneCount")
            }
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }


    }
}
