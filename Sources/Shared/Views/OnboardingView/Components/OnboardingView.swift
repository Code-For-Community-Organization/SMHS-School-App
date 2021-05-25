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
                if versionStatus == .new {
                    OnboardingRowItem(title: "Info Cards",
                                      description: "Tap on the vibrantly colored information cards to quickly link to a SMCHS web page, in app.",
                                      symbolImage: Image(systemSymbol: .squareGrid3x1FillBelowLineGrid1x2).foregroundColor(.secondary).font(.system(size: 50)))
                    OnboardingRowItem(title: "Redesigned Schedule",
                                      description: "Vibrantly colored, redesigned schedule blocks that makes SMHS app even better.",
                                      symbolImage: Image(systemSymbol: .sparkles).foregroundColor(.primary).font(.system(size: 50)))
                    OnboardingRowItem(title: "School Information",
                                      description: "Follow SMCHS on social medias! Find basic school directions and contacts in the bottom of search tab.",
                                      symbolImage: Image(systemSymbol: .infoCircleFill).foregroundColor(.secondary).font(.system(size: 50)))
                }
                else {
                    OnboardingRowItem(title: "Widgets",
                                      description: "Your daily schedule at a glance with iOS 14 Widgets.",
                                      symbolImage: Image(systemSymbol: .squareDashedInsetFill).foregroundColor(.primary).font(.system(size: 50)))
                    OnboardingRowItem(title: "Nutrition Schedule",
                                      description: "Use a segmented toggle to easily switch between 1st or 2nd lunch.",
                                      symbolImage: Image(systemSymbol: .calendarCircleFill).foregroundColor(.secondary).font(.system(size: 50)))
                    OnboardingRowItem(title: "Campus News",
                                      description: "Get updated on the newest campus news stories, in a supercharged experience.",
                                      symbolImage: Image(systemSymbol: .newspaperFill).foregroundColor(.primary).font(.system(size: 40)))
                }

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
