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
                ForEach(OnboardingFeature.newVersionFeatures.indices) {index in
                    OnboardingRowItem(featureDetails: OnboardingFeature.newVersionFeatures[index],
                                      isPrimary: (index % 2 == 0) ? true : false)
                }
            }

            Spacer()
            Button(action: {
                if AppVersionStatus.currentVersion == "1.2.6" {
                    showAlert = true
                }
                stayInPresentation = false
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
        if let url = Constants.joinTeamsURL {
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
