//
//  FooterModalView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/24/21.
//

import SwiftUI

struct FooterModalView: View {
    @EnvironmentObject var userSettings: UserSettings
    var dateHelper = ScheduleDateHelper()
    let legacyDescriptionText = """
        Toggling on will display schedules in a plain text style
        instead of formated blocks. Legacy schedule style sometimes
        might be more reliable and detailed (eg. sports).
"""
    
    var body: some View {
        NavigationView {
            SettingsView {
                Section(header: Text("\(dateHelper.todayDateDescription), Welcome!")
                                .textCase(nil)
                                .font(.title2, weight: .black)) {EmptyView()}

                Section(header: Label("Settings", systemSymbol: .gearshapeFill),
                        footer: Text(legacyDescriptionText).padding(.bottom)) {
                    Toggle("Legacy Schedule Style", isOn: $userSettings.preferLegacySchedule)
                }
                
                Section(header: Text("Period settings").textCase(nil),
                        footer: Text("Customize and edit your class names for each period. (Ex. Period 2 might be English)")
                            .textCase(nil)
                            .padding(.bottom)) {
                    ForEach(userSettings.editableSettings.indices, id: \.self){
                        PeriodEditItem(setting: $userSettings.editableSettings[$0])
                    }
                }
                
                Section(header: Label("Statements", systemSymbol: .infoCircle).textCase(nil)) {
                    NavigationLink("Acknowledgement", destination: Acknowledgements())
                    Link("Terms and Conditions", destination: URL(string: "https://smhs-schedule.flycricket.io/terms.html")!)
                    Link("Privacy Policy", destination: URL(string: "https://smhs-schedule.flycricket.io/privacy.html")!)
                }
                Section {
                    NavigationLink(destination: WhyStatementView()) {Label("Why", systemSymbol: .questionmark)}
                    NavigationLink(destination: HowStatementView()) {Label("How", systemSymbol: .gearshape2)}
                    NavigationLink(destination: FeaturesStatementView()) {Label("Features", systemSymbol: .sparkles)}
                    //NavigationLink(destination: Text("")) {Label("The Developer", systemSymbol: .personCropCircle)}
                }
                .foregroundColor(.secondary)
                
                Section(header: Label("Developer", systemSymbol: .hammerFill)){
                    Toggle(isOn: $userSettings.developerSettings.alwaysShowOnboarding, label: {
                        Text("Always show onboarding")
                    })
                    
                    Toggle(isOn: $userSettings.developerSettings.shouldCacheData, label: {
                        Text("Cache data")
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
                            .foregroundColor(.secondaryLabel)
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FooterModalView_Previews: PreviewProvider {
    static var previews: some View {
        FooterModalView()
    }
}
