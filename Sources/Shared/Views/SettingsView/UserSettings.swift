//
//  UserSettings.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/28/21.
//

import Combine
import Foundation

class UserSettings: ObservableObject {
    @Published(key: "developerSettings") var developerSettings = DeveloperSettings()
    @Published(key: "userSettings") var editableSettings = [EditableSetting]()
    init(){
        if editableSettings.isEmpty {
            resetEditableSettings()
        }


    }
    
    func resetEditableSettings()
    {
        let periods = 1...7
        var settings = [EditableSetting]()
        for period in periods {
            settings.append(.init(periodNumber: period, textContent: ""))
        }
        self.editableSettings = settings
    }
    
}
struct EditableSetting: Codable, Hashable {
    var periodNumber: Int
    var title: String {
        "Period \(periodNumber)"
    }
    var textContent: String
    
    static let sampleSetting = EditableSetting(periodNumber: 1, textContent: "")
}
struct DeveloperSettings: Codable {
    var alwaysLoadingState: Bool = false
    var alwaysShowOnboarding: Bool = false
    var shouldCacheData: Bool = true
}
