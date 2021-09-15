//
//  AppVersionStatus.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/30/21.
//

import UIKit

enum VersionStatus {
    case new, updated, stable
}

struct AppVersionStatus {
    //@Published var stayInPresentation = true
    static var appDisplayName: String {
        Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
    }

    static var currentVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    static func getVersionStatus() -> VersionStatus {
        let defaults = UserDefaults(suiteName: "AppVersion")
        guard let currentAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String, let previousVersion = defaults?.string(forKey: "appVersion") else {
            // Key does not exist in UserDefaults, must be a fresh install
            return .new
        }

        let comparisonResult = currentAppVersion.compare(previousVersion, options: .numeric, range: nil, locale: nil)
        switch comparisonResult {
        case .orderedDescending:
            //Updated
            return .updated
        default:
            //Remain same or downgraded
            return .stable
        }
    }

    static func setCurrentVersionStatus() {
        let defaults = UserDefaults(suiteName: "AppVersion")
        guard let currentAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {return}
        // Updating new version to UserDefaults
        defaults?.set(currentAppVersion, forKey: "appVersion")
    }
}
