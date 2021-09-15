//
//  OnboardingView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/30/21.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var userSettings: UserSettings

    var versionStatus = AppVersionStatus.getVersionStatus()

    @State var showAlert = false
    @Binding var stayInPresentation: Bool

    var body: some View {
        VStack {
            Group {
                let name = AppVersionStatus.appDisplayName
                if versionStatus == .new {
                    Text("Welcome to \(name)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                else {
                    Text("What's New in \(name)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.top, 50)
            .padding(.bottom, 50)

            VStack(spacing: 50) {
                OnboardingRowItem(title: "Join Our Teams!",
                                  description: "The SMHS app's Teams forum is now available for SMCHS students, using your school email.",
                                  symbolImage: Image(systemSymbol: .bubbleLeftFill)
                                    .foregroundColor(.appPrimary)
                                    .font(.largeTitle)
                                    .imageScale(.large))

                OnboardingRowItem(title: "Period 8",
                                  description: "Optionally turned off period 8 in settings.",
                                  symbolImage: Image(systemSymbol: ._8SquareFill)
                                    .foregroundColor(.appSecondary)
                                    .font(.largeTitle)
                                    .imageScale(.large))

                OnboardingRowItem(title: "Open Source",
                                  description: "SMHS Schedule is fully open source, contributions are welcome on Github.",
                                  symbolImage: Image(systemSymbol: .chevronLeftSlashChevronRight)
                                    .foregroundColor(.appPrimary)
                                    .font(.largeTitle)
                                    .imageScale(.large),
                                  linkTitle: "Learn more.",
                                  linkURL: "https://github.com/jevonmao/SMHS-Schedule")
            }

            Spacer()
            Button(action: {
                if AppVersionStatus.currentVersion == "1.2.6" {
                    showAlert = true
                }
            }, label: {
                Text("Continue")
                    .font(.body)
                    .fontWeight(.semibold)
            })
            .buttonStyle(HighlightButtonStyle())
            .padding(.bottom)
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Join SMHS Teams"),
                  message: Text("Recommend joining our official forum on Teams."),
                  primaryButton: .default(Text("Join"),
                                          action: handleJoinTeamsButton),
                  secondaryButton: .cancel(Text("Nah")) {
                    stayInPresentation = false
                  })

        })
    }

    func handleJoinTeamsButton() {
        if let url = getJoinTeamsURL() {
            openURL(url)
        }
        userSettings.didJoinTeams = true
        stayInPresentation = false
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(versionStatus: .stable, stayInPresentation: .constant(true))
        OnboardingView(versionStatus: .new, stayInPresentation: .constant(true))
        OnboardingView(versionStatus: .updated, stayInPresentation: .constant(true))
    }
}
