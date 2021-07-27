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
                OnboardingRowItem(title: "Grades",
                                  description: "View student grades from Aeries Gradebook.",
                                  symbolImage: Image(systemSymbol: .graduationcapFill).foregroundColor(.primary).font(.system(size: 50)))
                OnboardingRowItem(title: "Calendar",
                                  description: "Glance at school events in the new calendar.",
                                  symbolImage: Image(systemSymbol: .calendar).foregroundColor(.secondary).font(.system(size: 50)))
                OnboardingRowItem(title: "Redesigned Schedule",
                                  description: "Vibrantly colored, redesigned schedule blocks that makes SMHS app even better.",
                                  symbolImage: Image(systemSymbol: .sparkles).foregroundColor(.primary).font(.system(size: 50)))
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
