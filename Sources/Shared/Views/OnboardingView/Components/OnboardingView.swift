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
            .padding(.bottom, 80)
            VStack(spacing: 30) {
                OnboardingRowItem(title: "View Schedules",
                                  description: "Schedule for future dates, beautifully grouped by week, easily accesible on your fingle tips.",
                                  symbolImage: Image(systemSymbol: .calendar).foregroundColor(.primary).font(.system(size: 50)))
                OnboardingRowItem(title: "Today's Schedule",
                                  description: "Quickly access today's class schedules with ease, without tapping on any extra menus.",
                                  symbolImage: Image(systemSymbol: .squareGrid2x2Fill).foregroundColor(.secondary).font(.system(size: 50)))
                OnboardingRowItem(title: "About the Creator",
                                  description: "SMHS Schedule is created by Jevon Mao, a Freshman at SMHS who loves designing and coding.",
                                  symbolImage: Image(systemSymbol: .personCircleFill).foregroundColor(Color(UIColor.systemOrange)).font(.system(size: 50)))
                OnboardingRowItem(title: "Open Source",
                                  description: "SMHS Schedule is written in SwiftUI, fully open source, contributions are welcome on Github.",
                                  symbolImage: Image(systemSymbol: .chevronLeftSlashChevronRight).foregroundColor(Color(UIColor.systemPurple)).font(.system(size: 40)),
                                  linkTitle: "Learn more.",
                                  linkURL: "https://github.com/jevonmao/SMHS-Schedule")
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
