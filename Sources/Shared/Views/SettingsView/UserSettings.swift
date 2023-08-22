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
import UIKit

@MainActor
final class UserSettings: ObservableObject {
    //Developer-only settings for debug scheme
    @Published(key: "developerSettings") var developerSettings = DeveloperSettings()
    @Published(key: "userSettings") private var __editableSettings = [EditableSetting]()
    @Published(key: "preferLegacySchedule") var preferLegacySchedule = false
    @Published(key: "isPeriod8On") var isPeriod8On = true
    @Published(key: "didJoinTeams") var didJoinTeams = false

    // For schedule detail view
    @Published(key: "respondedSurvey") var respondedSurvey = false
    
    var anyCancellable: Set<AnyCancellable> = []
    
    init(){
        if __editableSettings.isEmpty {
            resetEditableSettings()
        }
        
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
            settings.append(.init(periodNumber: period))
        }
        self.__editableSettings = settings
    }

    func commitEditableSettings(_ settings: [EditableSetting]) {
        __editableSettings = settings
    }

    func resetDeveloperSettings()
    {
        self.developerSettings = DeveloperSettings()
    }

    func getEditableSettings() -> [EditableSetting] {
        __editableSettings
    }
}

struct EditableSetting: Codable, Hashable {
    internal init(periodNumber: Int, subject: Course, room: Classroom) {
        self.periodNumber = periodNumber
        self.subject = subject
        self.room = room
    }

    internal init(periodNumber: Int) {
        self.periodNumber = periodNumber
    }

    var periodNumber: Int
    var title: String {
        "Period \(periodNumber)"
    }
    var subject: Course?
    var room: Classroom?
    
    static let sampleSetting = EditableSetting(periodNumber: 1)
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
    var developerOn = false
}
