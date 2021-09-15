//
//  GlobalStore.swift
//  SMHS
//
//  Created by Jevon Mao on 9/6/21.
//

import Foundation
import Firebase
import FirebaseRemoteConfig

var globalRemoteConfig: RemoteConfig!

func getJoinTeamsURL() -> URL? {
    guard let link = globalRemoteConfig.configValue(forKey: "teams_link").stringValue
    else { return nil }

    guard let url = URL(string: link)
    else { return nil }

    return url
}
