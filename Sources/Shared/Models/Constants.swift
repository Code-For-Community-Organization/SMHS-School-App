//
//  GlobalStore.swift
//  SMHS
//
//  Created by Jevon Mao on 9/6/21.
//

import Foundation
import Firebase
import FirebaseRemoteConfig
import SwiftUI

//MARK: This file contains global, pre-defined constants
struct Constants {

    //MARK: - Firebase Remote Config Values
    static var remoteConfig: RemoteConfig!

    static var joinTeamsURL: URL? {
        guard let link = remoteConfig.configValue(forKey: "teams_link").stringValue
        else { return nil }

        guard let url = URL(string: link)
        else { return nil }

        return url
    }

    static var shouldShowJoinTeamsBanner: Bool {
        remoteConfig.configValue(forKey: "show_join_teams_banner").boolValue
    }
    
    static var gradeReloadInterval: TimeInterval {
        #if DEBUG
        0
        #else
        remoteConfig.configValue(forKey: "reload_interval_grade").numberValue.doubleValue
        #endif
    }

    static var scheduleReloadInterval: TimeInterval {
        #if DEBUG
        0
        #else
        remoteConfig.configValue(forKey: "reload_interval_schedule").numberValue.doubleValue
        #endif
    }

    static var noSchoolIdentifier: [String] {
        let data = remoteConfig.configValue(forKey: "no_school_identifier").jsonValue
        if let values = (data as? [String: [String]]),
           let identifiers = values["contains"] {
            return identifiers
        }
        else {
            return ["SMCHS Events", "Holiday"]
        }
    }

    static var shouldPurgeOnUpdate: Bool {
        remoteConfig.configValue(forKey: "purge_data_onupdate").boolValue
    }

    static var shouldShowOnboarding: Bool {
        remoteConfig.configValue(forKey: "show_onboarding").boolValue
    }

    static var scheduleSeperator: String {
        if let seperator = remoteConfig.configValue(forKey: "schedule_seperator")
            .stringValue {
            return seperator
        }
        else {
            return "-------"
        }
    }

    static var isPeriod8Enabled: Bool {
        remoteConfig.configValue(forKey: "eighth_period_enabled").boolValue
    }

    static var period8Days: [Int]? {
        // Get period 8 days of week from remote config
        let p8DaysConfig = Constants.remoteConfig.configValue(forKey: "period_eight_days").jsonValue

        // Expect JSON:
        // ex. {"days": [1,3,5]} for mon, wed, fri
        // Get first of dictionary, and get its period 8 days
        if let p8DaysConfig = p8DaysConfig as? [String: Any],
           let p8Days = p8DaysConfig.first?.value {
            //Cast as dictionary, with values as days
            guard let p8DayArray = p8Days as? NSArray
            else { return [] }

            let p8DayIntArray = p8DayArray
                    .compactMap({$0 as? NSString})
                    .compactMap({$0.integerValue})
            return p8DayIntArray
        }
        return nil
    }

    static var period8Times: (start: Date, end: Date)? {
        let timesConfig = Constants.remoteConfig.configValue(forKey: "period_eight_time").jsonValue

        //Get periods's start and end times from remote config
        if let times = timesConfig as? [String: String],
            // Get start/end values from dictionary
           // Format into Date objects
           let startTime = DateFormatter.hourTimeFormat(times["start"] ?? ""),
           let endTime = DateFormatter.hourTimeFormat(times["end"] ?? "") {
            return (startTime, endTime)
        }

        return nil
    }

    static var primaryColor: String? {
        Constants.remoteConfig.configValue(forKey: Constants.primaryColorKey).stringValue
    }

    static var secondaryColor: String? {
        Constants.remoteConfig.configValue(forKey: Constants.secondaryColorKey).stringValue
    }
}

extension Constants {

    //MARK: - App-wide Constant Values
    fileprivate static let primaryColorKey = "primary_color"
    static let primaryColorHex = "3498DB"

    fileprivate static let secondaryColorKey = "secondary_color"
    static let secondaryColorHex = "12C4A1"
}
