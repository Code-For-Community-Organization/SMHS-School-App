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
    static var remoteConfig: RemoteConfig!

    static var joinTeamsURL: URL? {
        guard let link = remoteConfig.configValue(forKey: "teams_link").stringValue
        else { return nil }

        guard let url = URL(string: link)
        else { return nil }

        return url
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
}

