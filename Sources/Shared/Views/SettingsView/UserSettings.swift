//
//  UserSettings.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/28/21.
//

import Combine

class UserSettings: ObservableObject {
    @Published(key: "developerSettings") var developerSettings = DeveloperSettings()
}

struct DeveloperSettings: Codable {
    var alwaysLoadingState: Bool = false
    var alwaysShowOnboarding: Bool = false
}
