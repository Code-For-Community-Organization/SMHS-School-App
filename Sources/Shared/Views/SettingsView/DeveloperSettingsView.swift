//
//  DeveloperSettingsView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/13/21.
//

import SwiftUI

struct DeveloperSettingsView: View {  //Developer-only settings for debug scheme
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        SettingsView {
            Section(header: Label("Developer Settings", systemSymbol: .hammerFill)){
                Toggle(isOn: $userSettings.developerSettings.alwaysLoadingState, label: {
                    Text("Always show loading")
                })
                
                Toggle(isOn: $userSettings.developerSettings.alwaysShowOnboarding, label: {
                    Text("Always show onboarding")
                })
                
                Toggle(isOn: $userSettings.developerSettings.shouldCacheData, label: {
                    Text("Cache data")
                })
                
                Toggle(isOn: $userSettings.developerSettings.overrideNetworkStatus) {
                    Text("Override network status")
                }
                
                Picker("Network Status", selection: $userSettings.developerSettings.networkStatus) {
                    ForEach(DeveloperSettings.networkStatus.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
            }
        }
    }
}

struct DeveloperSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperSettingsView()
    }
}
