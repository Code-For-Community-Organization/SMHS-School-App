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

        Section(header: Label("Developer", systemSymbol: .hammerFill)){
            Toggle(isOn: $userSettings.developerSettings.developerOn) {
                Text("Developer mode")
            }

            Toggle(isOn: $userSettings.developerSettings.alwaysShowOnboarding, label: {
                Text("Always show onboarding")
            })

            Toggle(isOn: $userSettings.developerSettings.shouldCacheData, label: {
                Text("Cache data")
            })

            Toggle(isOn: $userSettings.developerSettings.debugNetworking, label: {
                Text("Debug Networking Mode")
            })

            Toggle(isOn: $userSettings.developerSettings.dummyGrades, label: {
                Text("Dummy grades")
            })

            HStack {
                Text("Version")
                Spacer()
                if let text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    Text(text)
                        .foregroundColor(.secondaryLabel)
                }
            }

            HStack {
                Text("Build")
                Spacer()
                if let text = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                    Text(text)
                        .foregroundColor(.secondaryLabel)
                }
            }

            HStack {
                Text("OS")
                Spacer()
                Text(UIDevice.current.systemVersion)
            }
        }
    }
}

struct DeveloperSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperSettingsView()
    }
}
