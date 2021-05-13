//
//  DeveloperSettingsView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/13/21.
//

import SwiftUI

struct DeveloperSettingsView: View {
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

            }
        }
    }
}

struct DeveloperSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperSettingsView()
    }
}
