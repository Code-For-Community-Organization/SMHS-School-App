//
//  UserSettings.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/28/21.
//

import Combine
import Foundation
import Network
import FirebaseAnalytics

final class UserSettings: ObservableObject {
    //Developer-only settings for debug scheme
    @Published(key: "developerSettings") var developerSettings = DeveloperSettings()
    @Published(key: "userSettings") var editableSettings = [EditableSetting]()
    @Published(key: "preferLegacySchedule") var preferLegacySchedule = false
    var anyCancellable: Set<AnyCancellable> = []
    
    init(){
        if editableSettings.isEmpty {
            resetEditableSettings()
        }
        
        $editableSettings
            .removeDuplicates()
            .sink{[weak self] newValue in
                let settingsParameters = self?.editableSettings
                Analytics.logEvent("updated_periods", parameters: ["old_values": settingsParameters.debugDescription,
                                                                   "new_values": newValue.debugDescription])
            }
            .store(in: &anyCancellable)
        
        $preferLegacySchedule
            .removeDuplicates()
            .sink{newValue in
                Analytics.logEvent("updated_legacy_schedule",
                                   parameters: ["old_values": self.preferLegacySchedule.description,
                                                "new_values": newValue.description])
            }
            .store(in: &anyCancellable)
        
        #if DEBUG
        #else
        resetDeveloperSettings()
        #endif

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
    
    func resetDeveloperSettings()
    {
        self.developerSettings = DeveloperSettings()
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
    enum networkStatus: String, Codable, CaseIterable, Equatable {
        case unsatisfied, satisfied, requiresConnection
        var getNWPathStatus: NWPath.Status {
            switch self {
            case .requiresConnection:
                return .requiresConnection
            case .satisfied:
                return .satisfied
            case .unsatisfied:
                return .unsatisfied
            }
        }
    }
    var alwaysLoadingState: Bool = false
    var alwaysShowOnboarding: Bool = false
    var debugNetworking: Bool = false
    var shouldCacheData: Bool = true
    var overrideNetworkStatus: Bool = false
    var networkStatus: networkStatus = .unsatisfied
    var dummyGrades: Bool = false
}
