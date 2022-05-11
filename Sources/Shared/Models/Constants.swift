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
import Regex

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
}

extension Constants {

    struct Color {
        //MARK: - App-wide Constant Values
        private static let primaryKey = "primary_color"
        static let primaryHex = "3498DB"
        private static let secondaryKey = "secondary_color"
        static let secondaryHex = "12C4A1"

        static var fetchedPrimary: String? {
            let value = Constants.remoteConfig.configValue(forKey: primaryKey).stringValue
            guard !(value?.isEmpty ?? true)
            else {
                return primaryHex
            }
            return value
        }

        static var fetchedSecondary: String? {
            let value = Constants.remoteConfig.configValue(forKey: secondaryKey).stringValue
            guard !(value?.isEmpty ?? true)
            else {
                return secondaryHex
            }
            return value
        }
    }

    struct SmhsApiPath {
        static let host = "api.smhs.app"
        static let main = "/api/v1"
        static let annoucements = "/announcements"
    }

    struct AeriesApiPath {
        static let host = "aeries.smhs.org"
        static let main = "/parent/m/api/MobileWebAPI.asmx"
        static let login = "/parent/LoginParent.aspx"
        static let altGrades = "/Parent/Widgets/ClassSummary/GetClassSummary"
        static let summaryGrades = "/GetGradebookSummaryData"
        static let detailGrades = "/GetGradebookDetailsData"
        static let detailedSummary = "/GetGradebookDetailedSummaryData"


        static let pageSize = "200"
        static let requestedPage = "1"
    }

    struct AppServApiPath {
        static let host = "appserv.u360mobile.com"
        static let schedule = "/354/calendarfeed.php"


        static let pageSize = "25"
        static let pageNumber = "1"
        static let categoryId = "0"
        static let mid = "1422"
        static let smid = "46492"
    }

    struct Schedule {
        static let startTimePattern: Regex = #"((0?[1-9]|1[0-2]):[0-5][0-9]-)"#.r!
        static let endTimePattern: Regex = #"(-(0?[1-9]|1[0-2]):[0-5][0-9])"#.r!
        static let periodPattern = try! Regex(pattern: #"(per|period) \d+"#, options: [.caseInsensitive])
        static let officeHourPattern = try! Regex(pattern: #"(academic *per\w*)|(office *hours?)"#,
                                                  options: [.caseInsensitive])
        static let lunchPattern = try! Regex(pattern: #"^.*(lunch|nutrition).*$"#, options: [.caseInsensitive])
        static let distribution = "distribution"
    }

}
