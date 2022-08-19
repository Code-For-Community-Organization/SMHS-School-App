//
//  FooterModalView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/24/21.
//

import SwiftUI
import FirebaseAnalytics

struct FooterModalView: View {
    @EnvironmentObject var userSettings: UserSettings
    var dateHelper = ScheduleDateHelper()
    let legacyDescriptionText = "Display schedules in a plain text style instead of prettified blocks. (Try temporarily turning this on if schedule seems wrong)."
    
    var body: some View {
        NavigationView {
            SettingsView {
                Section(header: Text("\(dateHelper.todayDateDescription), Welcome!")
                                .font(.title2, weight: .black)) {EmptyView()}

                Section(header: Label("Settings", systemSymbol: .gearshapeFill),
                        footer: Text(legacyDescriptionText).padding(.bottom)) {
                    Toggle("Legacy Schedule Style", isOn: $userSettings.preferLegacySchedule)
                }
                Section(footer: Text("Whether to show period 8 in schedules. Most students don't have period 8").padding(.bottom)) {
                    Toggle("Period 8", isOn: $userSettings.isPeriod8On)
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
                    Link("Our Website", destination: URL(string: "https://smhs.app")!)
                    Link("Terms and Conditions", destination: URL(string: "https://smhs-schedule.flycricket.io/terms.html")!)
                    Link("Privacy Policy", destination: URL(string: "https://smhs.app/privacypolicy/")!)
                }

                Section(header: Label("Support", systemSymbol: .personFillQuestionmark).textCase(nil)) {
                    Link("I Need Help", destination: URL(string: "mailto:support@smhs.app")!)
                    Link("I Have a Privacy Concern", destination: URL(string: "mailto:privacy@smhs.app")!)
                    Link("I Have Other Questions", destination: URL(string: "mailto:maoj@codeforcommunity.ngo")!)
                }

                Section {
                    NavigationLink(destination: WhyStatementView()) {Label("Why", systemSymbol: .questionmark)}
                    NavigationLink(destination: HowStatementView()) {Label("How", systemSymbol: .gearshape2)}
                    NavigationLink(destination: FeaturesStatementView()) {Label("Features", systemSymbol: .sparkles)}
                    //NavigationLink(destination: Text("")) {Label("The Developer", systemSymbol: .personCropCircle)}
                }
                .foregroundColor(.appSecondary)
                
                DeveloperSettingsView()
            }
            .navigationBarTitle("Settings")
            .onAppear {
                Analytics.logEvent("settings&about_opened",
                                   parameters: nil)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FooterModalView_Previews: PreviewProvider {
    static var previews: some View {
        FooterModalView()
    }
}
