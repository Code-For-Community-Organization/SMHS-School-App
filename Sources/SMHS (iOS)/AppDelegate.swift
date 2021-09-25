//
//  SMHS_ScheduleApp.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI
import StoreKit
import Firebase
import FirebaseRemoteConfig

final class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        globalRemoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()

        #if DEBUG
        settings.minimumFetchInterval = 0
        #else
        let sixHours = 60 * 60 * 6
        settings.minimumFetchInterval = TimeInterval(sixHours)
        #endif

        globalRemoteConfig.configSettings = settings
        globalRemoteConfig.fetch {status, error in
            if status == .success {
                globalRemoteConfig.activate {_, _ in}
            } else {
                #if DEBUG
                debugPrint("Config not fetched")
                debugPrint("Error: \(error?.localizedDescription ?? "No error available.")")
                #endif
            }
        }
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

@main
struct SMHSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    init() {
        // get current number of times app has been launched (https://stackoverflow.com/questions/31966810/count-number-of-times-app-has-been-launched-using-swift)
        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
        let activeSceneCount = UserDefaults.standard.integer(forKey: "activeSceneCount")
        // increment received number by one
        UserDefaults.standard.set(currentCount+1, forKey:"launchCount")
        if currentCount > 8 ||
            activeSceneCount > 20 {
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
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