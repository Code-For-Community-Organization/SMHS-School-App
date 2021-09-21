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

var globalRemoteConfig: RemoteConfig!

var appPrimary: Color {
    if globalRemoteConfig.lastFetchStatus == .success {
        let colorHex = globalRemoteConfig.configValue(forKey: "primary_color").stringValue
        return Color(hexadecimal: colorHex ?? "3498DB")
    }
    return Color(hexadecimal: "3498DB")
}

var appSecondary: Color {
    if globalRemoteConfig.lastFetchStatus == .success {
        let colorHex = globalRemoteConfig.configValue(forKey: "secondary_color").stringValue
        return Color(hexadecimal: colorHex ?? "12C4A1")
    }
    return Color(hexadecimal: "12C4A1")
}

extension RemoteConfig {
    var getJoinTeamsURL: URL? {
        guard let link = globalRemoteConfig.configValue(forKey: "teams_link").stringValue
        else { return nil }

        guard let url = URL(string: link)
        else { return nil }

        return url
    }
}
