//
//  SMHS_ScheduleApp.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import StoreKit
import SwiftUI

// Require AppDelegate for some additional configurations
final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // Lock application to portrait mode only
    // TODO: Some UI views not optimized for landscape yet
    func application(_: UIApplication, supportedInterfaceOrientationsFor _: UIWindow?) -> UIInterfaceOrientationMask {
        AppDelegate.orientationLock
    }

    // Handle notification when the app is in background
    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response:
        UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        print("Notification tapped: \(response.notification.request.identifier)")
        completionHandler()
    }

    // Handle notification when the app is in foreground
    func userNotificationCenter(_: UNUserNotificationCenter,
                                willPresent _: UNNotification,
                                withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void)
    {
        print("Notification send in foreground")
        completionHandler([.banner, .list])
    }
}

@main
struct SMHS_ScheduleApp: App {
    // AppDelegate running side by side in SwiftUI App Cycle
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    init() {
        // get current number of times app has been launched (https://stackoverflow.com/questions/31966810/count-number-of-times-app-has-been-launched-using-swift)
        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
        let activeSceneCount = UserDefaults.standard.integer(forKey: "activeSceneCount")
        // increment received number by one
        UserDefaults.standard.set(currentCount + 1, forKey: "launchCount")
        if currentCount > 8 ||
            activeSceneCount > 20
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
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
