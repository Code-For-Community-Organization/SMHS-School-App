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
            Section(header: Label("Developer Settings", systemSymbol: .hammerFill)){
                    Toggle(isOn: $userSettings.developerSettings.alwaysLoadingState, label: {
                        Text("Always Show Loading")
                    })
                
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
