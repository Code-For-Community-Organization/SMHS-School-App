//
//  SMHS_ScheduleApp.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI
import FirebaseCore
import FirebaseRemoteConfig
import FirebaseMessaging
import FirebaseCrashlytics

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Configure Firebase Suite
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)

        UNUserNotificationCenter.current().delegate = self

        // Request authorization for push notifications
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()

        setupFirebaseRemoteConfig()

        #if DEBUG
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
        #endif
        // Configure notification delegates
        Messaging.messaging().delegate = self
        return true
    }

    // Lock app to portrait mode only
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

}

// MARK: - UNUserNotification
extension AppDelegate: UNUserNotificationCenterDelegate {
    // MARK: Delegate methods
    // Receive displayed notifications for iOS 10 devices
    // Called for when app is in background
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        let userInfo = notification.request.content.userInfo

        Messaging.messaging().appDidReceiveMessage(userInfo)
        // Change this to your preferred presentation option
        completionHandler([.banner, .sound, .list])
    }

    // Receive notification for when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler()
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(.noData)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    debugPrint("Device notification token: \(deviceToken.map { String(format: "%02.2hhx", $0) }.joined())")
      Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint(error)
    }


}

// MARK: Firebase Messaging
extension AppDelegate: MessagingDelegate {
    // MARK: Delegate methods
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        debugPrint("FCM Token: \(fcmToken ?? "")")

        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
          name: Notification.Name("FCMToken"),
          object: nil,
          userInfo: dataDict
        )
    }
}

extension AppDelegate {
    // Helper method, intializes Remote Config
    func setupFirebaseRemoteConfig() {
        // Remote config fetch
        // Allows developer to remotely update small
        // pieces of data that will change app behavior
        let config = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        #if DEBUG
        settings.minimumFetchInterval = 0
        #else
        let sixHours = 60 * 60 * 6
        settings.minimumFetchInterval = TimeInterval(sixHours)
        #endif

        config.configSettings = settings
        Constants.remoteConfig = config
        Constants.remoteConfig.fetchAndActivate {status, error in
            switch status {
            case .successFetchedFromRemote:
                debugPrint("✅ Success fetched from remote config")
            case .successUsingPreFetchedData:
                debugPrint("✅ Remote config use pre-fetched data")
            case .error:
                debugPrint("🚨 Remote config fetching error, \(error?.localizedDescription ?? "")")
            }
        }
        Constants.remoteConfig.configSettings.minimumFetchInterval = TimeInterval(Constants.minimumFetchInterval)

    }
}
