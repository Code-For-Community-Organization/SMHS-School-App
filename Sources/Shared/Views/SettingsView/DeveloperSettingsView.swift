//
//  DeveloperSettingsView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/13/21.
//

import SwiftUI

struct DeveloperSettingsView: View {  //Developer-only settings for debug scheme
    @EnvironmentObject var userSettings: UserSettings
    @State var value = 0.0

    var body: some View {
        Section(header: Label("Developer", systemSymbol: .hammerFill)){
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

            NavigationLink("More") {
                SettingsView {
                    Section(footer: Text("Well, this will be interesting 😈.")) {
                        Toggle("Show Toybox", isOn: $userSettings.isToyboxOn)
                    }
                    if userSettings.isToyboxOn {
                        Section(header: Text("Available Toybox Features")) {
                            NavigationLink(destination: {
//                                Button(action: {
//                                    userSettings.vibratorOn.toggle()
//                                    startVibrator()
//
//                                }, label: {
//                                    Text("Vibrate")
//                                })
                                Slider(value: $value, in: 0...100, onEditingChanged: {_ in
                                    var hapticManager = HapticsManager(impactStyle: .heavy)
                                    hapticManager.UIFeedbackImpact()
                                })
                                    .onChange(of: value){_ in
                                        print("Value set")
                                        var hapticManager = HapticsManager(impactStyle: .heavy)
                                        hapticManager.UIFeedbackImpact()
                                    }
                            }) {
                                HStack {
                                    appPrimary
                                        .frame(width: 30, height: 30)
                                        .roundedCorners(cornerRadius: 6)
                                        .overlay(
                                            Image(systemSymbol: .speakerWave3Fill)
                                                .foregroundColor(.white)
                                                .font(Font.subheadline.weight(.semibold))
                                        )

                                    Text("Haptics & Vibration")
                                }

                            }

                        }
                    }
                }
                .navigationTitle("More Settings")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    func startVibrator() {
        var hapticsManager = HapticsManager(impactStyle: .heavy)
//        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) {timer in
//            if !userSettings.vibratorOn {
//                timer.invalidate()
//            }
//            hapticsManager.oldSchoolVibrate()
//        }

        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) {timer in
            if !userSettings.vibratorOn {
                timer.invalidate()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                hapticsManager.UIFeedbackImpact()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                hapticsManager.UIFeedbackImpact()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                hapticsManager.UIFeedbackImpact()
            }
        }
    }
}

struct DeveloperSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperSettingsView()
    }
}
