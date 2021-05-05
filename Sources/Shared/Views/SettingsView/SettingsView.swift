//
//  SettingsView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/28/21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userSettings: UserSettings
    var body: some View {
        List {
            #if DEBUG
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
            #endif
        }
        .listStyle(GroupedListStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
