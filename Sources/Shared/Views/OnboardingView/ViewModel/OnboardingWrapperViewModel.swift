//
//  OnboardingWrapperViewModel.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/30/21.
//

import Foundation
import Combine

final class OnboardingWrapperViewModel: ObservableObject {
    @Published var stayInPresentation = true
    var versionStatus: AppVersionStatus
    
    init() {
        versionStatus = OnboardingWrapperViewModel.getVersionStatus()
    }
    
    static func getVersionStatus() -> AppVersionStatus {
        let defaults = UserDefaults(suiteName: "AppVersion")
        guard let currentAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String, let previousVersion = defaults?.string(forKey: "appVersion") else {
            // Key does not exist in UserDefaults, must be a fresh install
            if let currentAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
                //  Writing version to UserDefaults for the first time
                defaults?.set(currentAppVersion, forKey: "appVersion")
            }
            return .new
        }
        
        let comparisonResult = currentAppVersion.compare(previousVersion, options: .numeric, range: nil, locale: nil)
        defaults?.set(currentAppVersion, forKey: "appVersion")
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
