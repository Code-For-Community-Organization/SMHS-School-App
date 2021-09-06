//
//  OnboardingView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/30/21.
//

import SwiftUI

struct OnboardingView: View {
    var versionStatus: AppVersionStatus
    @Binding var stayInPresentation: Bool
    var body: some View {
        VStack {
            Group {
                if versionStatus == .new {
                    Text("Welcome to\nSMHS Schedule")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                else {
                    Text("What's New in\nSMHS Schedule")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.top, 50)
            .padding(.bottom, 50)
            VStack(spacing: 35) {
                OnboardingRowItem(title: "Daily Annoucements",
                                  description: "Get updated on daily annoucements, from today tab.",
                                  symbolImage: Image(systemSymbol: .megaphoneFill).foregroundColor(.appPrimary).font(.system(size: 50)))
                OnboardingRowItem(title: "Period 8",
                                  description: "Added period 8 for its days and time, just for you guys.",
                                  symbolImage: Image(systemSymbol: ._8SquareFill).foregroundColor(.appSecondary).font(.system(size: 50)))
                OnboardingRowItem(title: "New Details",
                                  description: "New yet long requested, you can now see which day's schedule you are glancing at.",
                                  symbolImage: Image(systemSymbol: .calendar).foregroundColor(.appSecondary).font(.system(size: 50)))
            }

            Spacer()
            Button(action: {stayInPresentation = false}, label: {
                Text("Continue")
                    .font(.body)
                    .fontWeight(.semibold)
            })
            .buttonStyle(HighlightButtonStyle())
            .padding(.bottom)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(versionStatus: .stable, stayInPresentation: .constant(true))
        OnboardingView(versionStatus: .new, stayInPresentation: .constant(true))
        OnboardingView(versionStatus: .updated, stayInPresentation: .constant(true))
    }
}
