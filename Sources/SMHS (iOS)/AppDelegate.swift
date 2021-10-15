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
import FirebaseMessaging

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
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

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
        }
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }

    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        // Change this to your preferred presentation option
        completionHandler([[.alert, .banner, .sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 1. Convert device token to string
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        // 2. Print device token to use for PNs payloads
        print("Device Token: \(token)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 1. Print out error if PNs registration not successful
        print("Failed to register for remote notifications with error: \(error)")
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        debugPrint("FCM Token: \(fcmToken ?? "")")
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

// MARK: UNUserNotification Delegate Methods
extension AppDelegate {

}

// MARK: Firebase Messaging Delegate Methods
extension AppDelegate {

}
